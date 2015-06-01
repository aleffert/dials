//
//  Plugin.h
//  Dials
//
//  Created by Akiva Leffert on 5/30/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Plugin;

@protocol PluginContext

/// Send a message to iOS
///
/// @param data the data to send
/// @param plugin The sending plugin
- (void)sendMessage:(NSData*)data plugin:(id <Plugin>)plugin;

/// Call this to add a new view controller to the sidebar grouped with this plugin.
/// The `title` property of the controller is used for display.
///
/// @param controller The controller to add.
/// @param plugin The sending plugin.
- (void)addViewController:(NSViewController*)controller plugin:(id <Plugin>)plugin;

/// Remove a controller from the sidebar.
///
/// @param controller The controller to add.
/// @param plugin The sending plugin.
- (void)removeViewController:(NSViewController*)controller plugin:(id <Plugin>)plugin;

@end

@protocol Plugin <NSObject>

/// Unique identifier for the plugin. Should match the corresponding iOS side plugin.
@property (readonly, nonatomic, copy) NSString* identifier;

/// User facing name of the plugin.
@property (readonly, nonatomic, copy) NSString* label;

/// Whether view controller children in the sidebar are sorted alphabetically.
/// If false, they will be sorted by the order in which they were added
@property (readonly, assign) BOOL shouldSortChildren;

/// Called when a message is received from the corresponding iOS plugin
/// @param data The message received
- (void)receiveMessage:(NSData*)message;

/// Called when a connection to a device is opened
///
/// @param context The communication channel between the plugin and its host
- (void)connectedWithContext:(id <PluginContext>)context;

/// Called when a connection to a device is closed.
/// After this call, the original context is no longer valid
- (void)connectionClosed;

@end

NS_ASSUME_NONNULL_END