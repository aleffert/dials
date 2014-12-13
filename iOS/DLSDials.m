//
//  DLSDials.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSDials.h"

#import <DialsShared.h>

@interface DLSDials () <NSNetServiceDelegate, DLSChannelStreamDelegate>

@property (strong, nonatomic) NSNetService* broadcastService;
@property (assign, nonatomic) BOOL running;
@property (strong, nonatomic) DLSChannelStream* stream;

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

- (void)start {
    if(!self.running) {
        [self startBroadcast];
    }
    self.running = YES;
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
}

- (void)stream:(DLSChannelStream *)stream receivedMessage:(NSData *)data onChannel:(DLSOwnedChannel *)channel {
    
}

- (void)streamClosed:(DLSChannelStream *)stream {
    self.stream = nil;
    [self startBroadcast];
}

@end
