//
//  DLSPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/13/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DLSPlugin;

@protocol DLSPluginContext <NSObject>

/// Send a message to the corresponding desktop plugin
- (void)sendMessage:(NSData*)message fromPlugin:(id <DLSPlugin>)plugin;

@end

/// Implement this protocol to add a new plugin. You will also need to register it
/// when you start DLSDials.
@protocol DLSPlugin <NSObject>

/// Unique identifier for a plugin. Should be the same as the name of the corresponding
/// desktop plugin
@property (readonly, nonatomic, copy) NSString* identifier;

/// Called when Dials is started. This is the place to do anything that needs to be
/// in place even before a desktop client is connected
- (void)start;

/// Called when a desktop connection is opened. The plugin should retain context
/// so that it can send messages
/// @param context An interface for communicating between the plugin and Dials
- (void)connectedWithContext:(id <DLSPluginContext>)context;

/// Called when a desktop connection is closed. At this point context should be cleared
- (void)connectionClosed;

/// Called when a message comes in from corresponding desktop plugin
/// @param message The data received from the corresponding desktop plugin
- (void)receiveMessage:(NSData*)message;

@end


NS_ASSUME_NONNULL_END