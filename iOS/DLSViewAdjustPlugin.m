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

@property (strong, nonatomic) NSHashTable* updatedViews;

@property (strong, nonatomic) id windowChangedListener;
@property (assign, nonatomic) BOOL viewChanged;

@end

@implementation DLSViewAdjustPlugin

+ (instancetype)sharedPlugin {
    static dispatch_once_t onceToken;
    static DLSViewAdjustPlugin* sharedPlugin;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[DLSViewAdjustPlugin alloc] init];
    });
    return sharedPlugin;
}


- (NSString*)name {
    return DLSViewAdjustPluginName;
}

- (void)connectedWithContext:(id<DLSPluginContext>)context {
    self.context = context;
    self.classDescriptions = [[NSMutableDictionary alloc] init];
    self.classPropertyDescriptions = [[NSMutableDictionary alloc] init];
    self.updatedViews = [NSHashTable weakObjectsHashTable];
    self.viewIDs = [NSMapTable strongToWeakObjectsMapTable];
    [self sendMessage:[self fullHierarchyMessage]];
    [UIView dls_setListening:YES];
    __weak __typeof(self) weakself = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIWindowDidBecomeVisibleNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        for(UIWindow* window in [[UIApplication sharedApplication] windows]) {
            [weakself viewChanged:window];
        }
    }];
}

- (void)connectionClosed {
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
    NSString* className = NSStringFromClass(klass);
    NSArray* result = self.classDescriptions[className];
    if(result == nil) {
        DLSDescriptionAccumulator* accumulator = [[DLSDescriptionAccumulator alloc] init];
        [klass dls_describe:accumulator];
        result = accumulator.groups;
        self.classDescriptions[className] = result;
    }
    return result;
}

- (NSString*)viewIDForView:(UIView*)view {
    NSString* viewID = view.dls_viewID;
    [self.viewIDs setObject:view forKey:viewID];
    return viewID;
}

- (DLSViewHierarchyRecord*)captureView:(UIView*)view {
    DLSViewHierarchyRecord* record = [[DLSViewHierarchyRecord alloc] init];
    record.viewID = [self viewIDForView:view];
    record.className = NSStringFromClass(view.class);
    record.displayName = record.className;
    record.children = [view.subviews dls_map:^id(UIView* child) {
        return [self viewIDForView:child];
    }];
    return record;
}

- (NSArray*)topLevelViewIDs {
    return [[[UIApplication sharedApplication] windows] dls_map:^id(UIWindow* window) {
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
    
    for(UIWindow* window in [[UIApplication sharedApplication] windows]) {
        [self captureView:window intoEntryMap:entries];
    }
    
    DLSViewAdjustFullHierarchyMessage* message = [[DLSViewAdjustFullHierarchyMessage alloc] init];
    message.hierarchy = entries;
    message.topLevel = [self topLevelViewIDs];
    
    return message;
}

#pragma mark Updates

- (void)sendInfoForView:(UIView*)view {
    DLSDescriptionAccumulator* accumulator = [[DLSDescriptionAccumulator alloc] init];
    [view dls_describe:accumulator];
    
    DLSViewAdjustViewPropertiesMessage* message = [[DLSViewAdjustViewPropertiesMessage alloc] init];
    
    DLSViewRecord* record = [[DLSViewRecord alloc] init];
    record.viewID = [self viewIDForView:view];
    record.propertyGroups = accumulator.groups;
    record.className = NSStringFromClass(view.class);
    NSMutableDictionary* values = [[NSMutableDictionary alloc] init];
    for(DLSPropertyGroup* group in record.propertyGroups) {
        NSMutableDictionary* groupValues = [[NSMutableDictionary alloc] init];
        for(DLSPropertyDescription* description in group.properties) {
            id <DLSValueExchanger> exchanger = [view dls_valueExchangerForProperty:description.name inGroup:group.displayName];
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

- (void)sendChangedViews {
    NSMutableArray* records = [[NSMutableArray alloc] init];
    for(UIView* view in self.updatedViews) {
        [records addObject:[self captureView:view]];
    }
    [self.updatedViews removeAllObjects];
    
    DLSViewAdjustUpdatedViewsMessage* message = [[DLSViewAdjustUpdatedViewsMessage alloc] init];
    message.records = records;
    message.topLevel = [self topLevelViewIDs];
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
    id <DLSValueExchanger> exchanger = [view dls_valueExchangerForProperty:message.record.name inGroup:message.record.group];
    [exchanger applyValue:message.record.value toObject:view];
}

@end


@implementation DLSViewAdjustPlugin (DLSPrivate)

- (void)viewChanged:(UIView *)view {
    [self.updatedViews addObject:view];
    if(!self.viewChanged) {
        self.viewChanged = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewChanged = NO;
            [self sendChangedViews];
        });
    }
    if(view == self.selectedView) {
        self.selectedView = nil;
        [self.updateTimer remove];
    }
}

@end