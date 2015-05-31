//
//  Plugin.m
//  Dials
//
//  Created by Akiva Leffert on 5/30/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Plugin;

@protocol PluginContext

- (void)sendMessage:(NSData*)data plugin:(id <Plugin>)plugin;

- (void)addViewController:(NSViewController*)controller plugin:(id <Plugin>)plugin;
- (void)removeViewController:(NSViewController*)controller plugin:(id <Plugin>)plugin;

@end

@protocol Plugin

@property (readonly, nonatomic, copy) NSString* name;
@property (readonly, nonatomic, copy) NSString* displayName;

@property (readonly, assign) BOOL shouldSortChildren;

- (void)receiveMessage:(NSData*)message;

- (void)connectedWithContext:(id <PluginContext>)context;

- (void)connectionClosed;

@end

NS_ASSUME_NONNULL_END
