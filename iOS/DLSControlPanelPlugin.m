//
//  DLSControlPanelPlugin.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/13/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSControlPanelPlugin.h"

#import "DLSActionEditor.h"
#import "DLSColorEditor.h"
#import "DLSFloatArrayEditor.h"
#import "DLSImageEditor.h"
#import "DLSControlPanelMessages.h"
#import "DLSControlInfo.h"
#import "DLSPropertyWrapper.h"
#import "DLSRemovable.h"
#import "DLSSliderEditor.h"
#import "DLSSourceLocation.h"
#import "DLSStepperEditor.h"
#import "DLSTextFieldEditor.h"
#import "DLSToggleEditor.h"

#import "NSGeometry+DLSWrappers.h"
#import "NSObject+DLSDeallocAction.h"

@interface DLSActiveControlRecord : NSObject <DLSRemovable>

@property (strong, nonatomic) DLSControlInfo* info;
@property (strong, nonatomic) DLSPropertyWrapper* wrapper;
@property (copy, nonatomic) void (^removeAction)(void);

@end

@implementation DLSActiveControlRecord

- (void)remove {
    self.removeAction();
    self.removeAction = nil;
}

@end

@interface DLSControlPanelPlugin ()

@property (strong, nonatomic) id <DLSPluginContext> context;

@property (strong, nonatomic) NSMutableDictionary<NSString*, DLSActiveControlRecord*>* activeControls;
@property (strong, nonatomic) NSMutableArray<NSString*>* groups;

@end

static DLSControlPanelPlugin* sActivePlugin;

@implementation DLSControlPanelPlugin

+ (instancetype)activePlugin {
    return sActivePlugin;
}

+ (void)setActivePlugin:(DLSControlPanelPlugin*)plugin {
    sActivePlugin = plugin;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        self.activeControls = [[NSMutableDictionary alloc] init];
        self.groups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)start {
    [DLSControlPanelPlugin setActivePlugin:self];
}


- (NSString*)identifier {
    return DLSControlPanelPluginIdentifier;
}

- (void)connectedWithContext:(id<DLSPluginContext>)context {
    self.context = context;
    for(DLSActiveControlRecord* record in self.activeControls.allValues) {
        [self sendAddMessageForControl:record.info];
    }
}

- (void)connectionClosed {
    self.context = nil;
}

- (void)removeRecordWithUUID:(NSString*)uuid {
    [self sendRemoveMessageWithUUID:uuid];
    [self.activeControls removeObjectForKey:uuid];
}

- (id <DLSRemovable>)addControlWithWrapper:(DLSPropertyWrapper*)wrapper editor:(id<DLSEditor>)editor owner:(id)owner label:(NSString*)label canSave:(BOOL)canSave file:(NSString*)file line:(size_t)line {
    
    DLSControlInfo* info = [[DLSControlInfo alloc] init];
    info.value = wrapper.getter();
    info.group = self.currentGroup;
    info.editor = editor;
    info.file = file;
    info.line = line;
    info.canSave = canSave;
    info.uuid = [NSUUID UUID].UUIDString;
    info.label = label;
    
    DLSActiveControlRecord* record = [[DLSActiveControlRecord alloc] init];
    record.wrapper = wrapper;
    record.info = info;
    __weak __typeof(self) weakself = self;
    __weak id <DLSRemovable> removable = [owner dls_performActionOnDealloc:^{
        [weakself removeRecordWithUUID:info.uuid];
    }];

    record.removeAction = ^{
        [weakself removeRecordWithUUID:info.uuid];
        [removable remove];
    };
    
    [self.activeControls setObject:record forKey:info.uuid];
    
    [self sendAddMessageForControl:info];
    return record;
}

#pragma mark Messages

- (void)sendMessage:(id <NSCoding>)message {
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    [self.context sendMessage:data fromPlugin:self];
}

- (void)receiveMessage:(NSData *)messageData {
    id message = [NSKeyedUnarchiver unarchiveObjectWithData:messageData];
    if([message isKindOfClass:[DLSControlPanelChangeMessage class]]) {
        [self handleChangeMessage:message];
    }
    else {
        NSAssert(NO, @"Unknown Message Type: %@", message);
    }
}

- (void)handleChangeMessage:(DLSControlPanelChangeMessage*)message {
    DLSActiveControlRecord* record = self.activeControls[message.uuid];
    record.info.value = message.value;
    if(record.wrapper.setter) {
        record.wrapper.setter(message.value);
    }
}

- (void)sendAddMessageForControl:(DLSControlInfo*)info {
    DLSControlPanelAddMessage* message = [[DLSControlPanelAddMessage alloc] init];
    message.info = info;
    message.group = info.group;
    [self sendMessage:message];
}

- (void)sendRemoveMessageWithUUID:(NSString*)uuid {
    DLSActiveControlRecord* record = self.activeControls[uuid];
    
    DLSControlPanelRemoveMessage* message = [[DLSControlPanelRemoveMessage alloc] init];
    message.uuid = uuid;
    message.group = record.info.group;
    [self sendMessage:message];
}

#pragma mark Groups

- (void)beginGroupWithName:(NSString *)name {
    [self.groups addObject:name];
}

- (NSString*)currentGroup {
    return [self.groups lastObject] ?: DLSControlPanelPluginDefaultGroup;
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

@interface DLSReferenceControlBuilder ()

@property (copy, nonatomic) NSString* label;
@property (assign, nonatomic) BOOL canSave;
@property (weak, nonatomic) id owner;
@property (copy, nonatomic) NSString* file;
@property (assign, nonatomic) size_t line;
@property (assign, nonatomic) BOOL used;

@end

@implementation DLSReferenceControlBuilder

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

- (void)dealloc {
    if(!self.used) {
        NSLog(@"Dials control not used: %@. %@:%ul", self.label, self.file, (unsigned int)self.line);
    }
}

- (id <DLSRemovable> (^)(dispatch_block_t))actionOf {
    return ^(dispatch_block_t action){
        
        DLSPropertyWrapper* wrapper = [[DLSPropertyWrapper alloc] initWithGetter:^id {
            return @"";
        } setter:^(id __nullable v) {
            action();
        }];
        
        self.used = true;
        return [[DLSControlPanelPlugin activePlugin] addControlWithWrapper:wrapper editor:[DLSActionEditor editor] owner:self.owner label:self.label canSave:NO file:self.file line:self.line];
    };
}

- (id <DLSRemovable> (^)(DLSPropertyWrapper*, id <DLSEditor>))wrapperOf {
    return ^(DLSPropertyWrapper* wrapper, id <DLSEditor> editor){
        self.used = true;
        return [[DLSControlPanelPlugin activePlugin] addControlWithWrapper:wrapper editor:editor owner:self.owner label:self.label canSave:YES file:self.file line:self.line];
    };
}

- (id <DLSRemovable>)buildWithEditor:(id <DLSEditor>)editor wrapper:(DLSPropertyWrapper*)wrapper {
    self.used = true;
    return [[DLSControlPanelPlugin activePlugin] addControlWithWrapper:wrapper editor:editor owner:self.owner label:self.label canSave:self.canSave file:self.file line:self.line];
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
DLSMake(imageOf, UIImage*, [[DLSImageEditor alloc] init])
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


@interface DLSKeyPathControlBuilder ()

@property (copy, nonatomic) NSString* keyPath;
@property (assign, nonatomic) BOOL canSave;
@property (weak, nonatomic) id owner;
@property (copy, nonatomic) NSString* file;
@property (assign, nonatomic) size_t line;

@property (assign, nonatomic) BOOL used;


@end

@implementation DLSKeyPathControlBuilder

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

- (void)dealloc {
    if(!self.used) {
        NSLog(@"Dials control not used: %@. %@:%ul", self.keyPath, self.file, (unsigned int)self.line);
    }
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
        self.used = true;
        DLSPropertyWrapper* wrapper = [[DLSPropertyWrapper alloc] initWithKeyPath:self.keyPath object:self.owner];
        return [[DLSControlPanelPlugin activePlugin] addControlWithWrapper:wrapper editor:editor owner:self.owner label:self.keyPath canSave:self.canSave file:self.file line:self.line];
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