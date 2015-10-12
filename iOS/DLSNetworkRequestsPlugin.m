//
//  DLSNetworkRequestsPlugin.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSNetworkRequestsPlugin.h"

#import "DLSNetworkRequestsMessages.h"
#import "DLSNetworkProxyProtocol.h"
#import "NSObject+DLSSwizzle.h"

@interface DLSNetworkRequestsPlugin () <DLSNetworkProxyProtocolDelegate>

@property (strong, nonatomic) id <DLSPluginContext> context;

@end

@implementation NSURLSessionConfiguration (DLSNetworkInterception)

- (NSArray*)dls_protocolClasses {
    NSArray* original = [self dls_protocolClasses];
    NSArray* result = [@[ [DLSNetworkProxyProtocol class] ] arrayByAddingObjectsFromArray:original];
    return result;
}

@end

@implementation DLSNetworkRequestsPlugin

- (NSString*)identifier {
    return DLSNetworkRequestsPluginIdentifier;
}

- (void)start {
    [NSURLProtocol registerClass:[DLSNetworkProxyProtocol class]];
    
    // NSURLSessionConfiguration is an illusion. The protocolClasses method
    // is only implemented on __NSCFURLSessionConfiguration which is the concrete
    // subclass returned by the NSURLSessionConfiguration class methods.
    // You can see this by calling [[NSURLSession alloc] init] and trying to
    // set the protocolClasses property on it which just crashes.
    // So instead of swizzling NSURLSessionConfiguration directly,
    // we just swizzle whatever class is returned here.
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    DLSSwizzle(configuration.class, protocolClasses);
    [DLSNetworkProxyProtocol setDelegate:self];
}

- (void)connectedWithContext:(id<DLSPluginContext>)context {
    self.context = context;
}

- (void)connectionClosed {
    self.context = nil;
}

- (void)receiveMessage:(NSData*)message {
    // No known messages
}

- (void)sendMessage:(DLSNetworkConnectionMessage*)message forConnectionID:(NSString*)connectionID {
    message.timestamp = [NSDate date];
    message.connectionID = connectionID;
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:message];
    [self.context sendMessage:data fromPlugin:self];
}

#pragma mark Protocol Delegate

- (void)connectionWithID:(NSString *)connectionID beganRequest:(NSURLRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        DLSNetworkConnectionBeganMessage* message = [[DLSNetworkConnectionBeganMessage alloc] init];
        message.request = request;
        [self sendMessage:message forConnectionID:connectionID];
    });
}

- (void)connectionWithID:(NSString *)connectionID failedWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        DLSNetworkConnectionFailedMessage* message = [[DLSNetworkConnectionFailedMessage alloc] init];
        message.error = error;
        [self sendMessage:message forConnectionID:connectionID];
    });
}

- (void)connectionWithID:(NSString *)connectionID receivedData:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        DLSNetworkConnectionReceivedDataMessage* message = [[DLSNetworkConnectionReceivedDataMessage alloc] init];
        message.data = data;
        [self sendMessage:message forConnectionID:connectionID];
    });
    
}

- (void)connectionWithID:(NSString *)connectionID completedWithResponse:(NSURLResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        DLSNetworkConnectionCompletedMessage* message = [[DLSNetworkConnectionCompletedMessage alloc] init];
        message.response = response;
        [self sendMessage:message forConnectionID:connectionID];
    });
}

- (void)connectionCancelledWithID:(NSString *)connectionID {
    dispatch_async(dispatch_get_main_queue(), ^{
        DLSNetworkConnectionCancelledMessage* message = [[DLSNetworkConnectionCancelledMessage alloc] init];
        [self sendMessage:message forConnectionID:connectionID];
    });
}

@end
