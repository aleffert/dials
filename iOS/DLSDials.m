//
//  DLSDials.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSDials.h"

#import "DLSLiveDialsPlugin.h"
#import "DLSPlugin.h"

/// Simple class to break the retain cycle, allowing a plugin to use a strong retain
/// of its context to simplify the interface
@interface DLSPluginContextBouncer : NSObject <DLSPluginContext>

@property (weak, nonatomic) id <DLSPluginContext> backingContext;

@end

@implementation DLSPluginContextBouncer

- (id <DLSChannel>)channelWithName:(NSString *)name forPlugin:(id <DLSPlugin>)plugin {
    return [self.backingContext channelWithName:name forPlugin:plugin];
}

- (void)sendMessage:(NSData *)message onChannel:(id<DLSChannel>)channel fromPlugin:(id <DLSPlugin>)plugin {
    [self.backingContext sendMessage:message onChannel:channel fromPlugin:plugin];
}

@end

@interface DLSDials () <NSNetServiceDelegate, DLSChannelStreamDelegate, DLSPluginContext>

@property (strong, nonatomic) NSNetService* broadcastService;
@property (assign, nonatomic) BOOL running;
@property (strong, nonatomic) DLSChannelStream* stream;

@property (strong, nonatomic) NSArray* plugins;
@property (strong, nonatomic) DLSPluginContextBouncer* contextBouncer;

@end

@implementation DLSDials

+ (DLSDials*)shared {
    static DLSDials* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DLSDials alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        self.plugins = @[].mutableCopy;
        self.contextBouncer = [[DLSPluginContextBouncer alloc] init];
        self.contextBouncer.backingContext = self;
    }
    return self;
}

- (NSArray*)defaultPlugins {
    return @[[DLSLiveDialsPlugin sharedPlugin]];
}

- (void)startWithPlugins:(NSArray*)plugins {
    
    NSAssert(!self.running, @"Error: Dials already started");
    self.plugins = plugins;
    [self startBroadcast];
    self.running = YES;
}

- (void)start {
    [self startWithPlugins:[self defaultPlugins]];
}

- (void)startBroadcast {
    NSString* appName = [[NSBundle mainBundle] infoDictionary][(__bridge NSString*)kCFBundleNameKey];
    self.broadcastService = [[NSNetService alloc] initWithDomain:@"" type:DLSNetServiceName name:appName];
    self.broadcastService.delegate = self;
    [self.broadcastService publishWithOptions:NSNetServiceListenForConnections];
}

- (void)stopBroadcast {
    [self.broadcastService stop];
    self.broadcastService = nil;
}

- (void)stop {
    if(self.running) {
        [self.broadcastService stop];
        self.broadcastService = nil;
    }
    self.running = NO;
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
    self.stream = [[DLSChannelStream alloc] initWithInputStream:inputStream outputStream:outputStream];
    self.stream.delegate = self;
    
    [self stopBroadcast];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        for(id <DLSPlugin> plugin in self.plugins) {
            [plugin connectedWithContext:self.contextBouncer];
        }
    });
}

- (void)stream:(DLSChannelStream *)stream receivedMessage:(NSData *)data onChannel:(DLSOwnedChannel *)channel {
    for(id <DLSPlugin> plugin in self.plugins) {
        if([plugin.name isEqual:channel.owner]) {
            [plugin receiveMessage:data onChannel:channel];
        }
    }
}

- (void)streamClosed:(DLSChannelStream *)stream {
    self.stream = nil;
    
    for(id <DLSPlugin> plugin in self.plugins) {
        [plugin connectionClosed];
    }
    
    [self startBroadcast];
}

- (void)sendMessage:(NSData *)message onChannel:(id<DLSChannel>)channel fromPlugin:(id<DLSPlugin>)plugin {
    [self.stream sendMessage:message onChannel:channel];
}

- (id <DLSChannel>)channelWithName:(NSString *)name forPlugin:(id <DLSPlugin>)plugin {
    return [[DLSOwnedChannel alloc] initWithOwner:plugin.name name:name];
}

@end
