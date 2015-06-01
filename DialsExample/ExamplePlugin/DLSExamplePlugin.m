//
//  DLSExamplePlugin.m
//  DialsExample
//
//  Created by Akiva Leffert on 6/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSExamplePlugin.h"

#import "DLSExamplePluginMessages.h"

@interface DLSExamplePlugin ()

@property (strong, nonatomic) id <DLSPluginContext> context;

@end

@implementation DLSExamplePlugin

- (NSString*)identifier {
    return DLSExamplePluginIdentifier;
}

- (void)start {
    
}

- (void)connectedWithContext:(id<DLSPluginContext> __nonnull)context {
    self.context = context;
}

- (void)connectionClosed {
    self.context = nil;
}

- (void)receiveMessage:(NSData * __nonnull)message {
    
}

@end
