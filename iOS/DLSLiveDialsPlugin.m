//
//  DLSLiveDialsPlugin.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/13/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSLiveDialsPlugin.h"

@implementation DLSPropertyWrapper

@end

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

@implementation DLSLiveDialsPlugin

+(instancetype)sharedPlugin {
    static dispatch_once_t onceToken;
    static DLSLiveDialsPlugin* sharedPlugin;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[DLSLiveDialsPlugin alloc] init];
    });
    return sharedPlugin;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        self.activeDials = [[NSMutableDictionary alloc] init];
        self.groups = [[NSMutableArray alloc] init];
    }
    return self;
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
    [self.activeDials removeObjectForKey:uuid];
    [self sendRemoveMessageWithUUID:uuid];
}

- (id <DLSRemovable>)addDialWithWrapper:(DLSPropertyWrapper*)wrapper value:(id)value editor:(id<DLSEditorDescription>)editor displayName:(NSString*)displayName file:(char *)file line:(size_t)line {
    __weak __typeof(self)owner = self;
    
    DLSLiveDial* dial = [[DLSLiveDial alloc] init];
    dial.value = value;
    dial.group = self.currentGroup;
    dial.editor = editor;
    dial.file = [NSString stringWithUTF8String:file];
    dial.line = line;
    dial.uuid = [NSUUID UUID].UUIDString;
    dial.displayName = displayName;
    
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

- (void)sendMessage:(id <NSCoding>)message onChannel:(id<DLSChannel>)channel {
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    [self.context sendMessage:data onChannel:channel fromPlugin:self];
}

- (void)receiveMessage:(NSData *)messageData onChannel:(id<DLSChannel>)channel {
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
    if(record.wrapper.setter) {
        record.wrapper.setter(message.value);
    }
}

- (void)sendAddMessageForDial:(DLSLiveDial*)dial {
    DLSLiveDialsAddMessage* message = [[DLSLiveDialsAddMessage alloc] init];
    message.dial = dial;
    id <DLSChannel> channel = [self.context channelWithName:dial.group forPlugin:self];
    [self sendMessage:message onChannel:channel];
}

- (void)sendRemoveMessageWithUUID:(NSString*)uuid {
    DLSLiveDialsRemoveMessage* message = [[DLSLiveDialsRemoveMessage alloc] init];
    message.uuid = uuid;
    DLSLiveDial* dial = self.activeDials[uuid];
    id <DLSChannel> channel = [self.context channelWithName:dial.group forPlugin:self];
    [self sendMessage:message onChannel:channel];
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

@end

@implementation NSObject (DLSLiveDialsHelpers)

- (id <DLSRemovable>)dls_addDialForGetter:(id(^)(void))getter setter:(void(^)(id))setter name:(NSString*)displayName editor:(id<DLSEditorDescription>)editor file:(char *)file line:(size_t)line {
    DLSPropertyWrapper* wrapper = [[DLSPropertyWrapper alloc] init];
    wrapper.getter = getter;
    wrapper.setter = setter;
    
    id value = wrapper.getter();
    id <DLSRemovable> removable = [[DLSLiveDialsPlugin sharedPlugin] addDialWithWrapper:wrapper value:value editor:editor displayName:displayName file:file line:line];
    [self dls_performActionOnDealloc:^{
        [removable remove];
    }];
    return removable;
}

- (id <DLSRemovable>)dls_addDialForProperty:(NSString *)property editor:(id<DLSEditorDescription>)editor file:(char *)file line:(size_t)line {
    __weak __typeof(self) weakself = self;
    id(^getter)(void) = ^{
        return [weakself valueForKeyPath:property];
    };
    void(^setter)(id) = ^(id value) {
        [weakself setValue:value forKeyPath:property];
    };

    return [self dls_addDialForGetter:getter setter:setter name:property editor:editor file:file line:line];
}

- (id <DLSRemovable>)dls_addDialForAction:(void (^)(void))action name:(NSString*)name file:(char *)file line:(size_t)line {
    id(^getter)(void) = ^id{
        return nil;
    };
    void(^setter)(id) = ^(id value) {
        action();
    };
    return [self dls_addDialForGetter:getter setter:setter name:name editor:[DLSActionDescription editor] file:file line:line];
}

@end