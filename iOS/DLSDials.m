//
//  DLSDials.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSDials.h"

#import <DialsShared.h>

@interface DLSDials () <NSNetServiceDelegate>

@property (strong, nonatomic) NSNetService* broadcastService;
@property (assign, nonatomic) BOOL running;

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
        NSString* appName = [[NSBundle mainBundle] infoDictionary][(__bridge NSString*)kCFBundleNameKey];
        self.broadcastService = [[NSNetService alloc] initWithDomain:@"" type:DLSNetServiceName name:appName];
        self.broadcastService.delegate = self;
        [self.broadcastService publishWithOptions:NSNetServiceListenForConnections];
    }
    self.running = YES;
}

- (void)stop {
    [self.broadcastService stop];
    self.broadcastService = nil;
    self.running = NO;
}

- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
}

@end
