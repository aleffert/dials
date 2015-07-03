//
//  DLSBufferedStreamWriter.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSBufferedStreamWriter.h"

#import "DLSBufferedStream.h"

@interface DLSQueuedMessage : NSObject

@property (assign, nonatomic) DLSStreamSize bytesRemaining;
@property (strong, nonatomic) NSData* data;

@end

@implementation DLSQueuedMessage
@end

@interface DLSBufferedStreamWriter () <NSStreamDelegate>

@property (strong, nonatomic) dispatch_queue_t queue;
@property (strong, nonatomic) NSMutableArray* messages;
@property (strong, nonatomic) NSOutputStream* stream;

@end

@implementation DLSBufferedStreamWriter

- (id)initWithOutputStream:(NSOutputStream *)stream {
    self = [super init];
    if(self != nil) {
        self.stream = stream;
        self.stream.delegate = self;
        self.queue = dispatch_queue_create("com.akivaleffert.streamwriter", DISPATCH_QUEUE_SERIAL);
        
        self.messages = [NSMutableArray array];
    }
    return self;
}

- (void)open {
    dispatch_async(self.queue, ^{
        [self.stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.stream open];
        while((self.stream.streamStatus == NSStreamStatusOpen
               || self.stream.streamStatus == NSStreamStatusOpening)
              && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    });
}

- (void)close {
    dispatch_async(self.queue, ^{
        self.stream.delegate = nil;
        [self.stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.stream close];
        self.stream = nil;
    });
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
            if(message) {
                [self sendAvailableBytes];
            }
            break;
        }
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventErrorOccurred:
        case NSStreamEventEndEncountered: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate streamWriterClosed:self];
            });
            break;
        }
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
