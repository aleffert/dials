//
//  DLSNetworkPlugin.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSNetworkPlugin.h"

#import "DLSNetworkProxyProtocol.h"

@interface DLSNetworkPlugin ()

@property (strong, nonatomic) id <DLSPluginContext> context;

@end

@implementation DLSNetworkPlugin

- (NSString*)name {
    return @"com.akivaleffert.dials.network";
}

- (void)start {
    [NSURLProtocol registerClass:[DLSNetworkProxyProtocol class]];
}

- (void)connectedWithContext:(id<DLSPluginContext> __nonnull)context {
    self.context = context;
}

- (void)connectionClosed {
    self.context = nil;
}

- (void)receiveMessage:(NSData * __nonnull)message {
    // No known messages
}

@end
