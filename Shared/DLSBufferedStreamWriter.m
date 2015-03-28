//
//  DLSBufferedStreamWriter.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSBufferedStreamWriter.h"

#import "DLSBufferedStream.h"

#import <arpa/inet.h>
#import <net/if.h>

@interface DLSQueuedMessage : NSObject

@property (assign, nonatomic) DLSStreamSize bytesRemaining;
@property (strong, nonatomic) NSData* data;

@end

@implementation DLSQueuedMessage
@end

@interface DLSBufferedStreamWriter () <NSStreamDelegate>

@property (strong, nonatomic) NSMutableArray* messages;
@property (strong, nonatomic) NSOutputStream* stream;

@end

@implementation DLSBufferedStreamWriter

- (id)initWithOutputStream:(NSOutputStream *)stream {
    self = [super init];
    if(self != nil) {
        self.stream = stream;
        self.stream.delegate = self;
        
        self.messages = [NSMutableArray array];
    }
    return self;
}

- (void)open {
    [self.stream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.stream open];
}

- (void)close {
    [self.stream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.stream = nil;
}

- (void)enqueueMessage:(NSData *)data {
    DLSQueuedMessage* headerMessage = [[DLSQueuedMessage alloc] init];
    headerMessage.bytesRemaining = sizeof(DLSStreamSize);
    DLSStreamSize length = CFSwapInt32HostToBig((DLSStreamSize)data.length);
    headerMessage.data = [[NSData alloc] initWithBytes:&length length:sizeof(DLSStreamSize)];
    [self.messages addObject:headerMessage];
    
    DLSQueuedMessage* bodyMessage = [[DLSQueuedMessage alloc] init];
    bodyMessage.data = data;
    bodyMessage.bytesRemaining = (DLSStreamSize)data.length;
    [self.messages addObject:bodyMessage];
    
    [self sendAvailableBytes];
}

- (void)sendAvailableBytes {
    while(self.stream.hasSpaceAvailable) {
        DLSQueuedMessage* message = [self.messages firstObject];
        if(message) {
            uint8_t* bytes = ((uint8_t*)message.data.bytes) + message.data.length - message.bytesRemaining;
            if(message.bytesRemaining != 0) {
                NSInteger bytesWritten = [self.stream write:bytes maxLength:message.bytesRemaining];
                message.bytesRemaining = message.bytesRemaining - (DLSStreamSize)bytesWritten;
            }
            if(message.bytesRemaining == 0) {
                [self.messages removeObject:message];
            }
        }
        else {
            break;
        }
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventErrorOccurred:
        case NSStreamEventEndEncountered:
            [self.delegate streamWriterClosed:self];
            break;
        case NSStreamEventHasSpaceAvailable:
            [self sendAvailableBytes];
            break;
        case NSStreamEventHasBytesAvailable:
        case NSStreamEventNone:
        case NSStreamEventOpenCompleted:
            break;
    }
}

@end
