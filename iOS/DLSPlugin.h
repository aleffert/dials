//
//  DLSPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/13/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DLSPlugin;

@protocol DLSPluginContext <NSObject>

// Send a message to the corresponding desktop plugin
- (void)sendMessage:(NSData* __nonnull)message fromPlugin:(__nonnull id <DLSPlugin>)plugin;

@end

@protocol DLSPlugin <NSObject>

@property (readonly, nonatomic, copy, nonnull) NSString* name;

/// Called when Dials is started. This is the place to do anything that needs to be
/// in place even before a desktop client is connected
- (void)start;

/// Called when a desktop connection is opened. The plugin should retain context
/// so that it can send messages
- (void)connectedWithContext:(id <DLSPluginContext> __nonnull)context;
/// Called when a desktop connection is closed. At this point context should be cleared
- (void)connectionClosed;
/// Called when a message comes in from corresponding desktop plugin
- (void)receiveMessage:(NSData* __nonnull)message;

@end
