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
#import "DLSDescribable.h"
#import "DLSViewAdjustMessages.h"
#import "NSArray+DLSFunctionalAdditions.h"
#import "UIView+DLSViewAdjust.h"

@interface DLSViewAdjustPlugin ()

/// NSString* (representing a class name) -> NSString* (representing a property name) -> DLSPropertyDescription
@property (strong, nonatomic) NSMutableDictionary* classPropertyDescriptions;
/// NSString* (representing a class name) -> Array of DLSDescriptionGroup*
@property (strong, nonatomic) NSMutableDictionary* classDescriptions;
@property (strong, nonatomic) id <DLSPluginContext> context;

@end

@implementation DLSViewAdjustPlugin

- (NSString*)name {
    return DLSViewAdjustPluginName;
}

- (void)receiveMessage:(NSData *)message onChannel:(id<DLSChannel>)channel {
    id fullMessage = [NSKeyedUnarchiver unarchiveObjectWithData:message];
    if([fullMessage isKindOfClass:[DLSViewAdjustRequestHierarchyMessage class]]) {
        [self handleRequestHierarchyMessage];
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

- (DLSViewHierarchyRecord*)captureView:(UIView*)view {
    DLSViewHierarchyRecord* record = [[DLSViewHierarchyRecord alloc] init];
    record.children = [view.subviews dls_map:^id(UIView* child) {
        return [self captureView:child];
    }];
    record.uuid = view.dls_uuid;
    record.className = NSStringFromClass(view.class);
    return record;
}

- (NSArray*)captureHierarchy {
    return [[[UIApplication sharedApplication] windows] dls_map:^(UIWindow* window) {
        return [self captureView:window];
    }];
}

- (void)connectedWithContext:(id<DLSPluginContext>)context {
    self.context = context;
    self.classDescriptions = [[NSMutableDictionary alloc] init];
    self.classPropertyDescriptions = [[NSMutableDictionary alloc] init];
}

- (void)connectionClosed {
    self.classDescriptions = nil;
    self.classPropertyDescriptions = nil;
    self.context = nil;
}

#pragma mark Message Handlers

- (void)sendMessage:(id <NSCoding>)message {
    NSData* messageData = [NSKeyedArchiver archivedDataWithRootObject:message];
    id <DLSChannel> channel = [self.context channelWithName:@"Views" forPlugin:self];
    [self.context sendMessage:messageData onChannel:channel fromPlugin:self];
}

- (void)handleRequestHierarchyMessage {
    DLSViewAdjustFullHierarchyMessage* message = [[DLSViewAdjustFullHierarchyMessage alloc] init];
    message.hierarchy = [self captureHierarchy];
    [self sendMessage:message];
}

@end
