//
//  DLSLiveDialsPlugin.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/13/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSLiveDialsPlugin.h"

#import "DLSActionEditor.h"
#import "DLSColorEditor.h"
#import "DLSFloatArrayEditor.h"
#import "DLSImageEditor.h"
#import "DLSLiveDialsMessages.h"
#import "DLSLiveDial.h"
#import "DLSPropertyWrapper.h"
#import "DLSRemovable.h"
#import "DLSSliderEditor.h"
#import "DLSStepperEditor.h"
#import "DLSTextFieldEditor.h"
#import "DLSToggleEditor.h"
#import "NSObject+DLSDeallocAction.h"

@interface DLSActiveDialRecord : NSObject <DLSRemovable>

@property (strong, nonatomic) DLSLiveDial* dial;
@property (strong, nonatomic) DLSPropertyWrapper* wrapper;
@property (copy, nonatomic) void (^removeAction)(void);

@end

@implementation DLSActiveDialRecord

- (void)remove {
    self.removeAction();
    self.removeAction = nil;
}

@end

@interface DLSLiveDialsPlugin ()

@property (strong, nonatomic) id <DLSPluginContext> context;

/// Contents are NSString* (uuid) -> DLSDialRecord*
@property (strong, nonatomic) NSMutableDictionary* activeDials;
/// Contents are NSString*
@property (strong, nonatomic) NSMutableArray* groups;

@end

static DLSLiveDialsPlugin* sActivePlugin;

@implementation DLSLiveDialsPlugin

+ (instancetype)activePlugin {
    return sActivePlugin;
}

+ (void)setActivePlugin:(DLSLiveDialsPlugin*)plugin {
    sActivePlugin = plugin;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        self.activeDials = [[NSMutableDictionary alloc] init];
        self.groups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)start {
    [DLSLiveDialsPlugin setActivePlugin:self];
}


- (NSString*)name {
    return DLSLiveDialsPluginName;
}

- (void)connectedWithContext:(id<DLSPluginContext>)context {
    self.context = context;
    for(DLSActiveDialRecord* record in self.activeDials.allValues) {
        [self sendAddMessageForDial:record.dial];
    }
}

- (void)connectionClosed {
    self.context = nil;
}

- (void)removeRecordWithUUID:(NSString*)uuid {
    [self sendRemoveMessageWithUUID:uuid];
    [self.activeDials removeObjectForKey:uuid];
}

- (id <DLSRemovable>)addDialWithWrapper:(DLSPropertyWrapper*)wrapper editor:(id<DLSEditor>)editor label:(NSString*)label canSave:(BOOL)canSave  file:(NSString*)file line:(size_t)line {
    __weak __typeof(self) owner = self;
    
    DLSLiveDial* dial = [[DLSLiveDial alloc] init];
    dial.value = wrapper.getter();
    dial.group = self.currentGroup;
    dial.editor = editor;
    dial.file = file;
    dial.line = line;
    dial.canSave = canSave;
    dial.uuid = [NSUUID UUID].UUIDString;
    dial.label = label;
    
    DLSActiveDialRecord* record = [[DLSActiveDialRecord alloc] init];
    record.wrapper = wrapper;
    record.dial = dial;
    record.removeAction = ^{
        [owner removeRecordWithUUID:dial.uuid];
    };
    
    [self.activeDials setObject:record forKey:dial.uuid];
    
    [self sendAddMessageForDial:dial];
    return record;
}

#pragma mark Messages

- (void)sendMessage:(id <NSCoding>)message {
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    [self.context sendMessage:data fromPlugin:self];
}

- (void)receiveMessage:(NSData *)messageData {
    id message = [NSKeyedUnarchiver unarchiveObjectWithData:messageData];
    if([message isKindOfClass:[DLSLiveDialsChangeMessage class]]) {
        [self handleChangeMessage:message];
    }
    else {
        NSAssert(NO, @"Unknown Message Type: %@", message);
    }
}

- (void)handleChangeMessage:(DLSLiveDialsChangeMessage*)message {
    DLSActiveDialRecord* record = self.activeDials[message.uuid];
    record.dial.value = message.value;
    if(record.wrapper.setter) {
        record.wrapper.setter(message.value);
    }
}

- (void)sendAddMessageForDial:(DLSLiveDial*)dial {
    DLSLiveDialsAddMessage* message = [[DLSLiveDialsAddMessage alloc] init];
    message.dial = dial;
    message.group = dial.group;
    [self sendMessage:message];
}

- (void)sendRemoveMessageWithUUID:(NSString*)uuid {
    DLSActiveDialRecord* record = self.activeDials[uuid];
    
    DLSLiveDialsRemoveMessage* message = [[DLSLiveDialsRemoveMessage alloc] init];
    message.uuid = uuid;
    message.group = record.dial.group;
    [self sendMessage:message];
}

#pragma mark Groups

- (void)beginGroupWithName:(NSString *)name {
    [self.groups addObject:name];
}

- (NSString*)currentGroup {
    return [self.groups lastObject] ?: DLSLiveDialsPluginDefaultGroup;
}

- (void)endGroup {
    [self.groups removeLastObject];
}

- (void)groupWithName:(NSString*)name actions:(void (^)(void))actions {
    [self beginGroupWithName:name];
    actions();
    [self endGroup];
}

@end

@interface DLSReferencePredial ()

@property (copy, nonatomic) NSString* label;
@property (assign, nonatomic) BOOL canSave;
@property (weak, nonatomic) id owner;
@property (copy, nonatomic) NSString* file;
@property (assign, nonatomic) size_t line;

@end

@implementation DLSReferencePredial

- (id)initWithLabel:(NSString *)label
            canSave:(BOOL)canSave
              owner:(id)owner
               file:(NSString *)file
               line:(size_t)line
{
    self = [super init];
    if(self != nil) {
        self.label = label;
        self.canSave = canSave;
        self.owner = owner;
        self.file = file;
        self.line = line;
    }
    return self;
}

- (id <DLSRemovable> (^)(dispatch_block_t))actionOf {
    DLSPropertyWrapper* wrapper = [[DLSPropertyWrapper alloc] initWithGetter:^id {
        return nil;
    } setter:^(id __nullable v) {
        // do nothing
    }];
    return ^(dispatch_block_t action){
        return [[DLSLiveDialsPlugin activePlugin] addDialWithWrapper:wrapper editor:[DLSActionEditor editor] label:self.label canSave:NO file:self.file line:self.line];
    };
}

- (id <DLSRemovable> (^)(DLSPropertyWrapper*, id <DLSEditor>))wrapperOf {
    return ^(DLSPropertyWrapper* wrapper, id <DLSEditor> editor){
        return [[DLSLiveDialsPlugin activePlugin] addDialWithWrapper:wrapper editor:editor label:self.label canSave:YES file:self.file line:self.line];
    };
}

- (id <DLSRemovable>)buildWithEditor:(id <DLSEditor>)editor wrapper:(DLSPropertyWrapper*)wrapper {
    return [[DLSLiveDialsPlugin activePlugin] addDialWithWrapper:wrapper editor:editor label:self.label canSave:self.canSave file:self.file line:self.line];
}

#define DLSMake(name, type, editor) \
- (id <DLSRemovable>(^)(type __strong *))name { \
    return ^(type __strong * value) { \
        DLSPropertyWrapper* wrapper = [[DLSPropertyWrapper alloc] initWithGetter:^{ \
            return *value; \
        } setter:^(type newValue) { \
            *value = newValue; \
        }]; \
        return [self buildWithEditor:editor wrapper:wrapper]; \
    }; \
}\

#define DLSMakeNumeric(name, type, getter, editor) \
- (id <DLSRemovable>(^)(type*))name { \
    return ^(type* value) { \
        DLSPropertyWrapper* wrapper = [[DLSPropertyWrapper alloc] initWithGetter:^{ \
            return @(*value); \
        } setter:^(NSNumber* newValue) { \
            *value = [newValue getter]; \
        }]; \
        return [self buildWithEditor:editor wrapper:wrapper]; \
    }; \
}\

#define DLSMakeWrapped(name, type, encoder, decoder, editor) \
- (id <DLSRemovable>(^)(type*))name { \
    return ^(type* value) { \
        DLSPropertyWrapper* wrapper = [[DLSPropertyWrapper alloc] initWithGetter:^{ \
            return encoder(*value); \
        } setter:^(NSDictionary* newValue) { \
            *value = decoder(newValue); \
        }]; \
        return [self buildWithEditor:editor wrapper:wrapper]; \
    }; \
}\


DLSMake(colorOf, UIColor*, [[DLSColorEditor alloc] init])
DLSMakeWrapped(edgeInsetsOf, UIEdgeInsets, DLSWrapUIEdgeInsets, DLSUnwrapUIEdgeInsets, [[DLSEdgeInsetsEditor alloc] init])
DLSMake(labelOf, NSString*, [DLSTextFieldEditor label])
DLSMakeWrapped(pointOf, CGPoint, DLSWrapCGPointPoint, DLSUnwrapCGPointPoint, [[DLSPointEditor alloc] init])
DLSMakeWrapped(sizeOf, CGSize, DLSWrapCGPointSize, DLSUnwrapCGPointSize, [[DLSSizeEditor alloc] init])
DLSMakeWrapped(rectOf, CGRect, DLSWrapCGPointRect, DLSUnwrapCGPointRect, [[DLSRectEditor alloc] init])
DLSMake(textFieldOf, NSString*, [DLSTextFieldEditor label])

- (id <DLSRemovable>(^)(CGFloat*, CGFloat, CGFloat))sliderOf {
    return ^(CGFloat* value, CGFloat min, CGFloat max) {
        DLSPropertyWrapper* wrapper = [[DLSPropertyWrapper alloc] initWithGetter:^id {
            return @(*value);
        } setter:^(id newValue) {
            *value = [newValue floatValue];
        }];
        return [self buildWithEditor:[[DLSSliderEditor alloc] initWithMin:min max:max] wrapper:wrapper];
    };
}

DLSMakeNumeric(stepperOf, CGFloat, floatValue, [DLSStepperEditor editor])
DLSMakeNumeric(toggleOf, BOOL, boolValue, [DLSToggleEditor editor])

@end


@interface DLSKeyPathPredial ()

@property (copy, nonatomic) NSString* keyPath;
@property (assign, nonatomic) BOOL canSave;
@property (weak, nonatomic) id owner;
@property (copy, nonatomic) NSString* file;
@property (assign, nonatomic) size_t line;


@end

@implementation DLSKeyPathPredial

- (id)initWithKeyPath:(NSString *)keyPath
            canSave:(BOOL)canSave
              owner:(id)owner
               file:(NSString *)file
               line:(size_t)line
{
    self = [super init];
    if(self != nil) {
        self.keyPath = keyPath;
        self.canSave = canSave;
        self.owner = owner;
        self.file = file;
        self.line = line;
    }
    return self;
}

- (id <DLSRemovable>(^)(id <DLSEditor>))asEditor {
    return [self asEditorWithGetterMap:^(id value){
        return value;
    } setterMap:^id(id value) {
        return value;
    }];
}

- (id <DLSRemovable>(^)(id <DLSEditor>))asEditorWithGetterMap:(id (^)(id))getterMap setterMap:(id (^)(id))setterMap {
    
    return ^(id <DLSEditor> editor) {
        DLSPropertyWrapper* wrapper = [[DLSPropertyWrapper alloc] initWithKeyPath:self.keyPath object:self.owner];
        return [[DLSLiveDialsPlugin activePlugin] addDialWithWrapper:wrapper editor:editor label:self.keyPath canSave:self.canSave file:self.file line:self.line];
    };
}

- (id<DLSRemovable>(^)(void))asColor {
    return ^{
        return self.asEditor([DLSColorEditor editor]);
    };
}

- (id<DLSRemovable>(^)(void))asEdgeInsets {
    return ^{
        return [self asEditorWithGetterMap:^id(NSValue* value) {
            UIEdgeInsets insets = [value UIEdgeInsetsValue];
            return DLSWrapUIEdgeInsets(insets);
        } setterMap:^id(NSDictionary* value) {
            return [NSValue valueWithUIEdgeInsets: DLSUnwrapUIEdgeInsets(value)];
        }]([[DLSEdgeInsetsEditor alloc] init]);
    };
}

- (id<DLSRemovable>(^)(void))asLabel {
    return ^{
        return self.asEditor([DLSTextFieldEditor label]);
    };
}

- (id<DLSRemovable>(^)(void))asImage {
    return ^{
        return self.asEditor([DLSImageEditor editor]);
    };
}

- (id<DLSRemovable>(^)(void))asPoint {
    return ^{
        return [self asEditorWithGetterMap:^id(NSValue* value) {
            CGPoint point = [value CGPointValue];
            return DLSWrapCGPointPoint(point);
        } setterMap:^id(NSDictionary* value) {
            return [NSValue valueWithCGPoint: DLSUnwrapCGPointPoint(value)];
        }]([[DLSPointEditor alloc] init]);
    };
}

- (id<DLSRemovable>(^)(void))asRect {
    return ^{
        return [self asEditorWithGetterMap:^id(NSValue* value) {
            CGRect rect = [value CGRectValue];
            return DLSWrapCGPointRect(rect);
        } setterMap:^id(NSDictionary* value) {
            return [NSValue valueWithCGRect: DLSUnwrapCGPointRect(value)];
        }]([[DLSRectEditor alloc] init]);
    };
}

- (id<DLSRemovable>(^)(void))asSize {
    return ^{
        return [self asEditorWithGetterMap:^id(NSValue* value) {
            CGSize size = [value CGSizeValue];
            return DLSWrapCGPointSize(size);
        } setterMap:^id(NSDictionary* value) {
            return [NSValue valueWithCGSize: DLSUnwrapCGPointSize(value)];
        }]([[DLSSizeEditor alloc] init]);
    };
}

- (id<DLSRemovable>(^)(void))asStepper {
    return ^{
        return self.asEditor([DLSStepperEditor editor]);
    };
}

- (id<DLSRemovable>(^)(void))asTextField {
    return ^{
        return self.asEditor([DLSTextFieldEditor textField]);
    };
}

- (id<DLSRemovable>(^)(CGFloat, CGFloat))asSlider {
    return ^(CGFloat min, CGFloat max){
        return self.asEditor([DLSSliderEditor sliderWithMin:min max:max]);
    };
}

- (id<DLSRemovable>(^)(void))asToggle {
    return ^{
        return self.asEditor([DLSToggleEditor editor]);
    };
}


@end