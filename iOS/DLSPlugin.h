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

- (void)sendMessage:(NSData* __nonnull)message fromPlugin:(__nonnull id <DLSPlugin>)plugin;

@end

@protocol DLSPlugin <NSObject>

@property (readonly, nonatomic, copy, nonnull) NSString* name;

- (void)receiveMessage:(NSData* __nonnull)message;

- (void)connectedWithContext:(id <DLSPluginContext> __nonnull)context;
- (void)connectionClosed;

@end
