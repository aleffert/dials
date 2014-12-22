//
//  DLSLiveDialsPlugin.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/13/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSLiveDialsPlugin.h"

@interface DLSLiveDialsPlugin ()

@property (strong, nonatomic) id <DLSPluginContext> context;

@end

@implementation DLSLiveDialsPlugin

- (NSString*)name {
    return @"com.akivaleffert.live-dials";
}

- (void)connectedWithContext:(id<DLSPluginContext>)context {
    self.context = context;
    id <DLSChannel> channel = [context channelWithName:@"test" forPlugin:self];
    [context sendMessage:[NSData data] onChannel:channel fromPlugin:self];
    channel = [context channelWithName:@"test1" forPlugin:self];
    [context sendMessage:[NSData data] onChannel:channel fromPlugin:self];
}

- (void)connectionClosed {
    
}

- (void)receiveMessage:(NSData *)message onChannel:(id<DLSChannel>)channel {
    // TODO
}

@end
