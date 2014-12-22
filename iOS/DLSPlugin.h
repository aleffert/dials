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

- (id <DLSChannel>)channelWithName:(NSString*)name forPlugin:(id <DLSPlugin>)plugin;
- (void)sendMessage:(NSData*)message onChannel:(id<DLSChannel>)channel fromPlugin:(id <DLSPlugin>)plugin;

@end

@protocol DLSPlugin <NSObject>

@property (readonly, nonatomic, copy) NSString* name;

- (void)receiveMessage:(NSData*)message onChannel:(id <DLSChannel>)channel;

- (void)connectedWithContext:(id <DLSPluginContext>)context;
- (void)connectionClosed;

@end
