//
//  DLSViewsPlugin.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 4/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSViewsPlugin.h"

#import "DLSConstraintsEditor.h"
#import "DLSConstraintsExchanger.h"
#import "DLSConstraintInformer.h"
#import "DLSDescriptionContext.h"
#import "DLSDescribable.h"
#import "DLSDescriptionAccumulator.h"
#import "DLSPropertyGroup.h"
#import "DLSRemovable.h"
#import "DLSPropertyDescription.h"
#import "DLSPropertyWrapper.h"
#import "DLSValueExchanger.h"
#import "DLSViewsMessages.h"
#import "DLSViewsPlugin+Internal.h"
#import "NSArray+DLSFunctionalAdditions.h"
#import "NSGeometry+DLSWrappers.h"
#import "NSTimer+DLSBlockActions.h"
#import "UIView+DLSDescribable.h"
#import "UIView+DLSViewsPlugin.h"

static const NSTimeInterval DLSViewUpdateInterval = .1;

@interface DLSViewDescriptionGenerator : NSObject
@property (copy, nonatomic) void(^generator)(id <DLSDescriptionContext>);
@property (strong, nonatomic) Class klass;
@end

@implementation DLSViewDescriptionGenerator

@end

@interface DLSViewsPlugin ()

@property (strong, nonatomic) NSMutableDictionary<NSString*, NSArray<DLSPropertyGroup*>*>* classDescriptions;

@property (strong, nonatomic) id <DLSPluginContext> context;

// strong -> weak so auto clears when the view gets cleared
@property (strong, nonatomic) NSMapTable* viewIDs;

@property (weak, nonatomic) UIView* selectedView;
@property (strong, nonatomic) id <DLSRemovable> selectionUpdateTimer;
@property (strong, nonatomic) id <DLSRemovable> updateDisplayTimer;
@property (strong, nonatomic) id <DLSRemovable> updateSurfaceTimer;

@property (strong, nonatomic) NSMutableSet<NSString*>* surfaceUpdatedViewIDs;
@property (strong, nonatomic) NSMutableSet<NSString*>* displayUpdatedViewIDs;

@property (strong, nonatomic) id windowChangedListener;

@property (strong, nonatomic) NSMutableArray<DLSViewDescriptionGenerator*>* viewDescriptionGenerators;
@property (strong, nonatomic) NSMutableArray<id<DLSConstraintInformer>>* constraintInformers;


@end

static DLSViewsPlugin* sActivePlugin;

@implementation DLSViewsPlugin

+ (instancetype)activePlugin {
    return sActivePlugin;
}

+ (void)setActivePlugin:(DLSViewsPlugin*)plugin {
    sActivePlugin = plugin;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        self.viewDescriptionGenerators = [[NSMutableArray alloc] init];
        self.constraintInformers = [[NSMutableArray alloc] init];
        [self installConstraintLoader];
    }
    return self;
}

- (NSString*)identifier {
    return DLSViewsPluginIdentifier;
}

- (void)start {
    [DLSViewsPlugin setActivePlugin:self];
}

- (void)connectedWithContext:(id<DLSPluginContext>)context {
    self.context = context;
    self.classDescriptions = [[NSMutableDictionary alloc] init];
    @synchronized(self) {
        self.surfaceUpdatedViewIDs = [[NSMutableSet alloc] init];
    }
    @synchronized(self) {
        self.displayUpdatedViewIDs = [[NSMutableSet alloc] init];
    }
    
    self.viewIDs = [NSMapTable strongToWeakObjectsMapTable];
    [self sendMessage:[self fullHierarchyMessage]];
    [self sendAllKnownViewContentsMessage];
    
    [UIView dls_setListeningForChanges:YES];
    __weak __typeof(self) weakself = self;
    self.windowChangedListener = [[NSNotificationCenter defaultCenter] addObserverForName:UIWindowDidBecomeVisibleNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        for(UIView* view in [self rootViews]) {
            [weakself viewChangedSurface:view];
        }
    }];
}

- (void)connectionClosed {
    @synchronized(self.surfaceUpdatedViewIDs) {
        self.surfaceUpdatedViewIDs = nil;
        [self.updateSurfaceTimer remove];
    }
    @synchronized(self.displayUpdatedViewIDs) {
        self.displayUpdatedViewIDs = nil;
        [self.updateDisplayTimer remove];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self.windowChangedListener];
    [UIView dls_setListeningForChanges:NO];
    self.classDescriptions = nil;
    self.context = nil;
    @synchronized(self.viewIDs) {
        self.viewIDs = nil;
    }
    self.selectedView = nil;
}

- (void)receiveMessage:(NSData *)message {
    id fullMessage = [NSKeyedUnarchiver unarchiveObjectWithData:message];
    if([fullMessage isKindOfClass:[DLSViewsSelectViewMessage class]]) {
        [self handleSelectViewMessage:fullMessage];
    }
    else if([fullMessage isKindOfClass:[DLSViewsValueChangedMessage class]]) {
        [self handleViewChangeMessage:fullMessage];
    }
    else if([fullMessage isKindOfClass:[DLSViewsInsetViewMessage class]]) {
        [self handleInsetViewMessage:fullMessage];
    }
    else {
        NSAssert(NO, @"Unknown message type: %@", fullMessage);
    }
}



- (id <DLSRemovable>)addExtraViewDescriptionForClass:(Class)klass generator:(void (^)(id<DLSDescriptionContext>))generator {
    DLSViewDescriptionGenerator* wrapper = [[DLSViewDescriptionGenerator alloc] init];
    wrapper.generator = generator;
    wrapper.klass = klass;
    [self.viewDescriptionGenerators addObject:wrapper];
    return [[DLSBlockRemovable alloc] initWithRemoveAction:^{
        [self.viewDescriptionGenerators removeObject:wrapper];
    }];
}

- (void)installConstraintLoader {
    __weak __typeof(self) owner = self;
    [self addExtraViewDescriptionForClass:[UIView class] generator:^(id<DLSDescriptionContext>  _Nonnull context) {
        [context addGroupWithName:@"Constraints"
                       properties:
         @[
           DLSProperty(@"Constraints", [[DLSConstraintsEditor alloc] init])
           .setExchanger([[DLSConstraintsExchanger alloc] initWithInformerProvider:
                          ^{
                              return owner.constraintInformers;
                          }])
           ]];
    }];
}

- (id <DLSRemovable>)addAuxiliaryConstraintInformer:(id <DLSConstraintInformer>)informer {
    [self.constraintInformers addObject:informer];
    return [[DLSBlockRemovable alloc] initWithRemoveAction:^{
        [self.constraintInformers removeObject:informer];
    }];
}

- (NSArray<DLSPropertyGroup*>*)propertyGroupsForClass:(Class)klass {
    if(klass == nil) {
        return @[];
    }
    
    NSString* className = NSStringFromClass(klass);
    NSArray<DLSPropertyGroup*>* result = self.classDescriptions[className];
    if(result == nil) {
        DLSDescriptionAccumulator* accumulator = [[DLSDescriptionAccumulator alloc] init];
        for(DLSViewDescriptionGenerator* wrapper in self.viewDescriptionGenerators) {
            if([klass isSubclassOfClass:wrapper.klass]) {
                wrapper.generator(accumulator);
            }
        }
        [klass dls_describe:accumulator];
        result = accumulator.groups.reverseObjectEnumerator.allObjects;
        self.classDescriptions[className] = result;
    }
    return result;
}


- (DLSViewRenderingRecord*)renderingInfoForView:(UIView*)view {
    DLSViewRenderingRecord* record = [[DLSViewRenderingRecord alloc] init];
    record.borderColor = view.layer.borderColor ? [[UIColor alloc] initWithCGColor:view.layer.borderColor] : nil;
    record.backgroundColor = view.backgroundColor;
    record.transform3D = view.layer.transform;
    
    
    NSMutableDictionary<NSString*, id>* contentValues = [[NSMutableDictionary alloc] init];
    for(NSString* key in @[
                           @"borderWidth",
                           @"contentsRect",
                           @"contentsCenter",
                           @"contentMode",
                           @"contentsGravity",
                           @"contentsScale",
                           @"cornerRadius",
                           @"hidden",
                           @"opacity",
                           @"shadowOpacity",
                           @"shadowRadius",
                           @"shadowOffset"]) {
        id value = [view.layer valueForKey:key];
        if(value == nil) {
            contentValues[key] = [NSNull null];
        }
        else {
            contentValues[key] = value;
        }
    }
    
    NSMutableDictionary<NSString*, id>* geometryValues = [[NSMutableDictionary alloc] init];
    for(NSString* key in @[
                           @"anchorPoint",
                           @"bounds",
                           @"position",
                           ]) {
        geometryValues[key] = [view.layer valueForKey:key];
    }
    
    record.contentValues = contentValues;
    record.geometryValues = geometryValues;
    return record;
}

- (DLSViewHierarchyRecord*)captureView:(UIView*)view {
    DLSViewHierarchyRecord* record = [[DLSViewHierarchyRecord alloc] init];
    record.viewID = [self viewIDForView:view];
    record.superviewID = [self viewIDForView:view.superview];
    record.className = NSStringFromClass(view.class);
    record.label = record.className;
    record.children = [view.subviews dls_map:^id(UIView* child) {
        return [self viewIDForView:child];
    }];
    record.selectable = [view isKindOfClass:[UIWindow class]] ? [(UIWindow*)view isKeyWindow] : YES;
    record.address = [NSString stringWithFormat:@"%p", view];
    record.renderingInfo = [self renderingInfoForView:view];
    return record;
}

- (NSArray<UIView*>*)rootViews {
    return [[UIApplication sharedApplication] windows];
}

- (NSArray<NSString*>*)rootViewIDs {
    return [[self rootViews] dls_map:^id(UIView* view) {
        return [self viewIDForView:view];
    }];
}

- (void)captureView:(UIView*)view intoEntryMap:(NSMutableDictionary<NSString*, DLSViewHierarchyRecord*>*)entries {
    DLSViewHierarchyRecord* record = [self captureView:view];
    [entries setObject:record forKey:record.viewID];
    for(UIView* subview in view.subviews) {
        [self captureView:subview intoEntryMap:entries];
    }
}

- (DLSViewsFullHierarchyMessage*)fullHierarchyMessage {
    NSMutableDictionary<NSString*, DLSViewHierarchyRecord*>* entries = [[NSMutableDictionary alloc] init];
    
    for(UIView* view in [self rootViews]) {
        [self captureView:view intoEntryMap:entries];
    }
    
    DLSViewsFullHierarchyMessage* message = [[DLSViewsFullHierarchyMessage alloc] init];
    message.hierarchy = entries;
    message.roots = [self rootViewIDs];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    message.screenSize = screenSize;
    
    return message;
}

- (void)sendAllKnownViewContentsMessage {
    NSMutableArray<NSString*>* views = [[NSMutableArray alloc] init];
    @synchronized(self.viewIDs) {
        for(NSString* key in self.viewIDs.keyEnumerator) {
            [views addObject:key];
        }
    }
    [self sendChangedDisplayViews:views];
}

#pragma mark Updates

- (void)sendInfoForView:(UIView*)view {
    DLSViewsViewPropertiesMessage* message = [[DLSViewsViewPropertiesMessage alloc] init];
    
    DLSViewRecord* record = [[DLSViewRecord alloc] init];
    record.viewID = [self viewIDForView:view];
    record.propertyGroups = [self propertyGroupsForClass:view.class];
    record.className = NSStringFromClass(view.class);
    NSMutableDictionary<NSString*, NSDictionary<NSString*, id<NSCoding>>*>* values = [[NSMutableDictionary alloc] init];
    for(DLSPropertyGroup* group in record.propertyGroups) {
        NSMutableDictionary<NSString*, id <NSCoding>>* groupValues = [[NSMutableDictionary alloc] init];
        for(DLSPropertyDescription* description in group.properties) {
            DLSValueExchanger* exchanger = description.exchanger;
            id <NSCoding> value = [exchanger wrapperFromObject:view].getter();
            if(value != nil) {
                groupValues[description.name] = value;
            }
        }
        values[group.label] = groupValues;
    }
    record.values = values;
    message.record = record;
    
    [self sendMessage:message];
}

- (void)startSendingUpdatesForView:(UIView*)view {
    [self.selectionUpdateTimer remove];
    
    __weak __typeof(self) weakself = self;
    self.selectionUpdateTimer = [NSTimer dls_scheduledTimerWithTimeInterval:.1 repeats:YES action:^{
        if(weakself.selectedView == nil) {
            [weakself.selectionUpdateTimer remove];
            weakself.selectionUpdateTimer = nil;
        }
        else {
            [self sendInfoForView:weakself.selectedView];
        }
    }];
}

- (void)sendChangedSurfaceViews {
    for(NSString* viewID in [self rootViewIDs]) {
        [self.surfaceUpdatedViewIDs addObject:viewID];
    }
    

    NSMutableArray<UIView*>* views = [[NSMutableArray alloc] init];
    @synchronized(self.viewIDs) {
        for(NSString* viewID in self.surfaceUpdatedViewIDs) {
            UIView* view = [self.viewIDs objectForKey:viewID];
            if(view != nil) {
                [views addObject:view];
            }
        }
    }
    
    NSMutableArray<DLSViewHierarchyRecord*>* records = [[NSMutableArray alloc] init];
    for(UIView* view in views) {
        [records addObject:[self captureView:view]];
    }

    DLSViewsUpdatedViewsMessage* message = [[DLSViewsUpdatedViewsMessage alloc] init];
    message.records = records;
    message.roots = [self rootViewIDs];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    message.screenSize = screenSize;
    [self sendMessage:message];
}

- (void)sendChangedDisplayViews:(NSArray<NSString*>*)viewIDs {
    NSMutableArray<UIView*>* views = [[NSMutableArray alloc] init];
    for(NSString* viewID in viewIDs) {
        UIView* view = [self.viewIDs objectForKey:viewID];
        if(view != nil) {
            [views addObject:view];
        }
    }
    
    NSMutableDictionary<NSString*, NSData*>* records = [[NSMutableDictionary alloc] init];
    NSMutableArray<NSString*>* empties = [[NSMutableArray alloc] init];
    for(UIView* view in views) {
        id image = view.layer.contents;
        UIImage* uiImage = nil;
        if(image != nil) {
            if([[image description] containsString:@"CGImage"]) {
                uiImage = [UIImage imageWithCGImage:(__bridge CGImageRef)image];
            }
            else {
                UIGraphicsBeginImageContextWithOptions(view.layer.bounds.size, NO, view.layer.rasterizationScale);
                CGContextRef context = UIGraphicsGetCurrentContext();
                [view.layer drawInContext:context];
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                uiImage = result;
            }
            
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
    
    DLSViewsUpdatedContentsMessage* message = [[DLSViewsUpdatedContentsMessage alloc] init];
    message.contents = records;
    message.empties = empties;
    
    [self sendMessage:message];
}

#pragma mark Message Handlers

- (void)sendMessage:(id <NSCoding>)message {
    NSData* messageData = [NSKeyedArchiver archivedDataWithRootObject:message];
    [self.context sendMessage:messageData fromPlugin:self];
}

- (void)handleInsetViewMessage:(DLSViewsInsetViewMessage*)message {
    UIView* view = [self.viewIDs objectForKey:message.viewID];
    UIEdgeInsets insets = DLSUnwrapUIEdgeInsets(message.insets);
    view.frame = UIEdgeInsetsInsetRect(view.frame, insets);
}

- (void)handleSelectViewMessage:(DLSViewsSelectViewMessage*)message {
    UIView* view = [self.viewIDs objectForKey:message.viewID];
    self.selectedView = view;
    [self sendInfoForView:view];
    if(view != nil) {
        [self startSendingUpdatesForView:view];
    }
}

- (void)handleViewChangeMessage:(DLSViewsValueChangedMessage*)message {
    UIView* view = [self.viewIDs objectForKey:message.record.viewID];
    NSArray<DLSPropertyGroup*>* groups = [self propertyGroupsForClass:view.class];
    for(DLSPropertyGroup* group in groups) {
        if([group.label isEqual:message.record.group]) {
            for(DLSPropertyDescription* description in group.properties) {
                if([description.name isEqual:message.record.name]) {
                    [description.exchanger wrapperFromObject:view].setter(message.record.value);
                }
            }
        }
    }
}

@end

@implementation DLSViewsPlugin (Internal)

- (NSString*)viewIDForView:(UIView*)view {
    if(view == nil) {
        return nil;
    }
    NSString* viewID = view.dls_assignedViewID;
    @synchronized(self.viewIDs) {
        if(viewID == nil) {
            viewID = view.dls_viewID;
            [self.viewIDs setObject:view forKey:view.dls_viewID];
        }
    }
    return viewID;
}

- (void)viewChangedSurface:(UIView *)view {
    if(view == nil) {
        return;
    }
    
    if(view == self.selectedView) {
        self.selectedView = nil;
        [self.selectionUpdateTimer remove];
    }
    @synchronized(self.surfaceUpdatedViewIDs) {
        NSString* viewID = [self viewIDForView:view];
        [self.surfaceUpdatedViewIDs addObject:viewID];
        if(self.updateSurfaceTimer == nil) {
            __weak __typeof(self) weakself = self;
            self.updateSurfaceTimer = [NSTimer dls_scheduledTimerWithTimeInterval:DLSViewUpdateInterval repeats:NO action:^{
                @synchronized(weakself.surfaceUpdatedViewIDs) {
                    weakself.updateSurfaceTimer = nil;
                    [weakself sendChangedSurfaceViews];
                    [weakself.surfaceUpdatedViewIDs removeAllObjects];
                }
            }];
        }
    }
}

- (void)viewChangedDisplay:(UIView *)view {
    if(view == nil) {
        return;
    }
    
    NSString* viewID = [self viewIDForView:view];
    @synchronized(self.displayUpdatedViewIDs) {
        [self.displayUpdatedViewIDs addObject:viewID];
        if(self.updateDisplayTimer == nil) {
            __weak __typeof(self) weakself = self;
            self.updateDisplayTimer = [NSTimer dls_scheduledTimerWithTimeInterval:DLSViewUpdateInterval repeats:NO action:^{
                @synchronized(self.displayUpdatedViewIDs) {
                    weakself.updateDisplayTimer = nil;
                    [weakself sendChangedDisplayViews:self.displayUpdatedViewIDs.allObjects];
                    [weakself.displayUpdatedViewIDs removeAllObjects];
                }
            }];
        }
    }
}

@end