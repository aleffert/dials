//
//  DLSViewAdjustPlugin.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 4/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSViewAdjustPlugin.h"

#import <DialsShared.h>
#import "DLSDescriptionContext.h"
#import "DLSPropertyGroup.h"
#import "DLSDescribable.h"
#import "DLSPropertyDescription.h"
#import "DLSValueExchanger.h"
#import "DLSViewAdjustMessages.h"
#import "NSArray+DLSFunctionalAdditions.h"
#import "NSTimer+DLSBlockActions.h"
#import "UIView+DLSDescribable.h"
#import "UIView+DLSViewAdjust.h"

@interface DLSViewAdjustPlugin ()

/// NSString* (representing a class name) -> NSString* (representing a property name) -> DLSPropertyDescription
@property (strong, nonatomic) NSMutableDictionary* classPropertyDescriptions;
/// NSString* (representing a class name) -> Array of DLSDescriptionGroup*
@property (strong, nonatomic) NSMutableDictionary* classDescriptions;
@property (strong, nonatomic) id <DLSPluginContext> context;

@property (strong, nonatomic) NSMapTable* viewIDs;

@property (weak, nonatomic) UIView* selectedView;
@property (strong, nonatomic) id <DLSRemovable> updateTimer;

@property (strong, nonatomic) NSHashTable* surfaceUpdatedViews;
@property (strong, nonatomic) NSHashTable* displayUpdatedViews;

@property (strong, nonatomic) id windowChangedListener;
@property (assign, nonatomic) BOOL surfaceViewChanged;
@property (assign, nonatomic) BOOL displayViewChanged;

@end

static DLSViewAdjustPlugin* sActivePlugin;

@implementation DLSViewAdjustPlugin

+ (instancetype)activePlugin {
    return sActivePlugin;
}

+ (void)setActivePlugin:(DLSViewAdjustPlugin*)plugin {
    sActivePlugin = plugin;
}

- (NSString*)name {
    return DLSViewAdjustPluginName;
}

- (void)start {
    [DLSViewAdjustPlugin setActivePlugin:self];
}

- (void)connectedWithContext:(id<DLSPluginContext>)context {
    self.context = context;
    self.classDescriptions = [[NSMutableDictionary alloc] init];
    self.classPropertyDescriptions = [[NSMutableDictionary alloc] init];
    self.surfaceUpdatedViews = [NSHashTable weakObjectsHashTable];
    self.displayUpdatedViews = [NSHashTable weakObjectsHashTable];
    self.viewIDs = [NSMapTable strongToWeakObjectsMapTable];
    [self sendMessage:[self fullHierarchyMessage]];
    [self sendAllKnownViewContentsMessage];
    
    [UIView dls_setListening:YES];
    __weak __typeof(self) weakself = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIWindowDidBecomeVisibleNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        for(UIView* view in [self rootViews]) {
            [weakself viewChangedSurface:view];
        }
    }];
}

- (void)connectionClosed {
    self.surfaceUpdatedViews = nil;
    self.displayUpdatedViews = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self.windowChangedListener];
    [UIView dls_setListening:NO];
    self.classDescriptions = nil;
    self.classPropertyDescriptions = nil;
    self.context = nil;
    self.viewIDs = nil;
    self.selectedView = nil;
}

- (void)receiveMessage:(NSData *)message {
    id fullMessage = [NSKeyedUnarchiver unarchiveObjectWithData:message];
    if([fullMessage isKindOfClass:[DLSViewAdjustSelectViewMessage class]]) {
        [self handleSelectViewMessage:fullMessage];
    }
    else if([fullMessage isKindOfClass:[DLSViewAdjustValueChangedMessage class]]) {
        [self handleViewChangeMessage:fullMessage];
    }
    else {
        NSAssert(NO, @"Unknown message type: %@", fullMessage);
    }
}

- (NSArray*)descriptionGroupsForClass:(Class)klass {
    if(klass == nil) {
        return @[];
    }
    
    NSString* className = NSStringFromClass(klass);
    NSArray* result = self.classDescriptions[className];
    if(result == nil) {
        DLSDescriptionAccumulator* accumulator = [[DLSDescriptionAccumulator alloc] init];
        [klass dls_describe:accumulator];
        result = accumulator.groups.reverseObjectEnumerator.allObjects;
        self.classDescriptions[className] = result;
    }
    return result;
}

- (NSString*)viewIDForView:(UIView*)view {
    NSString* viewID = view.dls_viewID;
    [self.viewIDs setObject:view forKey:viewID];
    return viewID;
}

- (DLSViewRenderingRecord*)renderingInfoForView:(UIView*)view {
    DLSViewRenderingRecord* record = [[DLSViewRenderingRecord alloc] init];
    record.anchorPoint = view.layer.anchorPoint;
    record.borderColor = view.layer.borderColor ? [[UIColor alloc] initWithCGColor:view.layer.borderColor] : nil;
    record.borderWidth = view.layer.borderWidth;
    record.bounds = view.layer.bounds;
    record.opacity = view.layer.opacity;
    record.position = view.layer.position;
    record.backgroundColor = view.backgroundColor;
    record.cornerRadius = view.layer.cornerRadius;
    record.transform3D = view.layer.transform;
    return record;
}

- (DLSViewHierarchyRecord*)captureView:(UIView*)view {
    DLSViewHierarchyRecord* record = [[DLSViewHierarchyRecord alloc] init];
    record.viewID = [self viewIDForView:view];
    record.superviewID = [self viewIDForView:view.superview];
    record.className = NSStringFromClass(view.class);
    record.displayName = record.className;
    record.children = [view.subviews dls_map:^id(UIView* child) {
        return [self viewIDForView:child];
    }];
    record.address = [NSString stringWithFormat:@"%p", view];
    record.renderingInfo = [self renderingInfoForView:view];
    return record;
}

- (NSArray*)rootViews {
    return [[[UIApplication sharedApplication] windows] dls_map:^(UIWindow* window) {
        return window.isKeyWindow ? window : nil;
    }];
}

- (NSArray*)rootViewIDs {
    return [[self rootViews] dls_map:^id(UIWindow* window) {
        return [self viewIDForView:window];
    }];
}

- (void)captureView:(UIView*)view intoEntryMap:(NSMutableDictionary*)entries {
    DLSViewHierarchyRecord* record = [self captureView:view];
    [entries setObject:record forKey:record.viewID];
    for(UIView* subview in view.subviews) {
        [self captureView:subview intoEntryMap:entries];
    }
}

- (DLSViewAdjustFullHierarchyMessage*)fullHierarchyMessage {
    NSMutableDictionary* entries = [[NSMutableDictionary alloc] init];
    
    for(UIView* view in [self rootViews]) {
        [self captureView:view intoEntryMap:entries];
    }
    
    DLSViewAdjustFullHierarchyMessage* message = [[DLSViewAdjustFullHierarchyMessage alloc] init];
    message.hierarchy = entries;
    message.roots = [self rootViewIDs];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    message.screenSize = screenSize;
    
    return message;
}

- (void)sendAllKnownViewContentsMessage {
    NSMutableArray* views = [[NSMutableArray alloc] init];
    for(NSString* key in self.viewIDs.keyEnumerator) {
        UIView* view = [self.viewIDs objectForKey:key];
        if(key) {
            [views addObject:view];
        }
    }
    [self sendChangedDisplayViews:views];
}

#pragma mark Updates

- (void)sendInfoForView:(UIView*)view {
    
    DLSViewAdjustViewPropertiesMessage* message = [[DLSViewAdjustViewPropertiesMessage alloc] init];
    
    DLSViewRecord* record = [[DLSViewRecord alloc] init];
    record.viewID = [self viewIDForView:view];
    record.propertyGroups = [self descriptionGroupsForClass:view.class];
    record.className = NSStringFromClass(view.class);
    NSMutableDictionary* values = [[NSMutableDictionary alloc] init];
    for(DLSPropertyGroup* group in record.propertyGroups) {
        NSMutableDictionary* groupValues = [[NSMutableDictionary alloc] init];
        for(DLSPropertyDescription* description in group.properties) {
            id <DLSValueExchanger> exchanger = [view.class dls_valueExchangerForProperty:description.name inGroup:group.displayName];
            id <NSCoding> value = [exchanger extractValueFromObject:view];
            if(value != nil) {
                groupValues[description.name] = value;
            }
        }
        values[group.displayName] = groupValues;
    }
    record.values = values;
    message.record = record;
    
    [self sendMessage:message];
}

- (void)startSendingUpdatesForView:(UIView*)view {
    [self.updateTimer remove];
    
    __weak __typeof(self) weakself = self;
    self.updateTimer = [NSTimer dls_scheduledTimerWithTimeInterval:.1 repeats:YES action:^{
        if(weakself.selectedView == nil) {
            [weakself.updateTimer remove];
            weakself.updateTimer = nil;
        }
        else {
            [self sendInfoForView:weakself.selectedView];
        }
    }];
}

- (void)sendChangedSurfaceViews {
    for(UIView* view in [self rootViews]) {
        [self.surfaceUpdatedViews addObject:view];
    }
    
    NSMutableArray* records = [[NSMutableArray alloc] init];
    for(UIView* view in self.surfaceUpdatedViews) {
        [records addObject:[self captureView:view]];
    }
    
    DLSViewAdjustUpdatedViewsMessage* message = [[DLSViewAdjustUpdatedViewsMessage alloc] init];
    message.records = records;
    message.roots = [self rootViewIDs];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    message.screenSize = screenSize;
    [self sendMessage:message];
}

- (void)sendChangedDisplayViews:(NSArray*)views {
    NSMutableDictionary* records = [[NSMutableDictionary alloc] init];
    NSMutableArray* empties = [[NSMutableArray alloc] init];
    for(UIView* view in views) {
        id image = view.layer.contents;
        UIImage* uiImage = nil;
        if(image != nil) {
            UIGraphicsBeginImageContextWithOptions(view.layer.bounds.size, NO, view.layer.rasterizationScale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [view.layer drawInContext:context];
            UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            uiImage = result;
            
            NSData* imageData = UIImagePNGRepresentation(uiImage);
            if(imageData) {
                records[[self viewIDForView:view]] = imageData;
            }
            else {
                [empties addObject:[self viewIDForView:view]];
            }
        }
        else {
            [empties addObject:[self viewIDForView:view]];
        }
    }
    
    DLSViewAdjustUpdatedContentsMessage* message = [[DLSViewAdjustUpdatedContentsMessage alloc] init];
    message.contents = records;
    message.empties = empties;
    
    [self sendMessage:message];
}

#pragma mark Message Handlers

- (void)sendMessage:(id <NSCoding>)message {
    NSData* messageData = [NSKeyedArchiver archivedDataWithRootObject:message];
    [self.context sendMessage:messageData fromPlugin:self];
}

- (void)handleSelectViewMessage:(DLSViewAdjustSelectViewMessage*)message {
    UIView* view = [self.viewIDs objectForKey:message.viewID];
    self.selectedView = view;
    [self sendInfoForView:view];
    if(view != nil) {
        [self startSendingUpdatesForView:view];
    }
}

- (void)handleViewChangeMessage:(DLSViewAdjustValueChangedMessage*)message {
    UIView* view = [self.viewIDs objectForKey:message.record.viewID];
    id <DLSValueExchanger> exchanger = [view.class dls_valueExchangerForProperty:message.record.name inGroup:message.record.group];
    [exchanger applyValue:message.record.value toObject:view];
}

@end


@implementation DLSViewAdjustPlugin (DLSPrivate)

- (void)viewChangedSurface:(UIView *)view {
    if(view == nil) {
        return;
    }
    [self.surfaceUpdatedViews addObject:view];
    if(!self.surfaceViewChanged) {
        self.surfaceViewChanged = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.surfaceViewChanged = NO;
            [self sendChangedSurfaceViews];
            [self.surfaceUpdatedViews removeAllObjects];
        });
    }
    if(view == self.selectedView) {
        self.selectedView = nil;
        [self.updateTimer remove];
    }
}

- (void)viewChangedDisplay:(UIView *)view {
    if(view == nil) {
        return;
    }
    [self.displayUpdatedViews addObject:view];
    if(!self.displayViewChanged) {
        self.displayViewChanged = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.displayViewChanged = NO;
            [self sendChangedDisplayViews:self.displayUpdatedViews.allObjects];
            [self.displayUpdatedViews removeAllObjects];
        });
    }
}

@end