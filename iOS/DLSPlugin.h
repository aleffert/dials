//
//  DLSPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/13/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSChannel;
@protocol DLSPlugin;

@protocol DLSPluginContext <NSObject>

- (id <DLSChannel> __nonnull)channelWithName:( NSString* __nonnull )name forPlugin:(__nonnull id <DLSPlugin>)plugin;
- (void)sendMessage:(NSData* __nonnull)message onChannel:(id<DLSChannel> __nonnull)channel fromPlugin:(__nonnull id <DLSPlugin>)plugin;

@end

@protocol DLSPlugin <NSObject>

@property (readonly, nonatomic, copy) NSString*__nonnull name;

- (void)receiveMessage:(NSData* __nonnull)message onChannel:(id <DLSChannel> __nonnull)channel;

- (void)connectedWithContext:(id <DLSPluginContext> __nonnull)context;
- (void)connectionClosed;

@end
