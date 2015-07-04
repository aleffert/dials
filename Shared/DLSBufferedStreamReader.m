//
//  DLSBufferedStreamReader.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSBufferedStreamReader.h"

#import "DLSBufferedStream.h"

typedef NS_ENUM(NSUInteger, DLSBufferedStreamReaderState) {
    DLSBufferedStreamReaderStateReadingHeader,
    DLSBufferedStreamReaderStateReadingBody,
};

@interface DLSBufferedStreamReader () <NSStreamDelegate>

@property (strong, nonatomic) NSRunLoop* queueLoop;
@property (strong, nonatomic) dispatch_queue_t queue;
@property (strong, nonatomic) NSInputStream* stream;
@property (assign, nonatomic) DLSBufferedStreamReaderState readState;
@property (assign, nonatomic) DLSStreamSize bytesRemaining;
@property (strong, nonatomic) NSMutableData* buffer;

@end

@implementation DLSBufferedStreamReader

- (id)initWithInputStream:(NSInputStream *)stream {
    self = [super init];
    if(self != nil) {
        self.queue = dispatch_queue_create("com.akivaleffert.streamreader", DISPATCH_QUEUE_SERIAL);
        self.stream = stream;
        self.stream.delegate = self;
        [self prepareForHeader];
    }
    return self;
}

- (void)open {
    dispatch_async(self.queue, ^{
        self.queueLoop = [NSRunLoop currentRunLoop];
        [self.stream scheduleInRunLoop:self.queueLoop forMode:NSDefaultRunLoopMode];
        [self.stream open];
        [self pumpStream:self.stream];
    });
}

- (void)close {
    dispatch_async(self.queue, ^{
        self.queueLoop = nil;
        self.stream.delegate = nil;
        [self.stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.stream close];
        self.stream = nil;
    });
}

- (void)prepareForHeader {
    self.readState = DLSBufferedStreamReaderStateReadingHeader;
    self.bytesRemaining = sizeof(DLSStreamSize);
    self.buffer = [NSMutableData dataWithLength:self.bytesRemaining];
}

- (void)pumpStream:(NSStream*)stream {
    [self.queueLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
    if(self.stream.streamStatus != NSStreamStatusClosed) {
        NSStream* stream = self.stream;
        dispatch_async(self.queue, ^{
            [self pumpStream:stream];
        });
    }
}

- (void)readHeader {
    uint8_t* bytes = self.buffer.mutableBytes + self.buffer.length - self.bytesRemaining;
    NSInteger bytesRead = [self.stream read:bytes maxLength:self.bytesRemaining];
    self.bytesRemaining = self.bytesRemaining - (DLSStreamSize)bytesRead;
    if(self.bytesRemaining == 0) {
        int32_t bodySize = 0;
        [self.buffer getBytes:&bodySize length:sizeof(bodySize)];
        self.bytesRemaining = (DLSStreamSize)CFSwapInt32BigToHost(bodySize);
        if(self.bytesRemaining == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate streamReader:self receivedMessage:[NSData data]];
            });
            [self prepareForHeader];
        }
        else {
            self.buffer = [NSMutableData dataWithLength:self.bytesRemaining];
            self.readState = DLSBufferedStreamReaderStateReadingBody;
        }
    }
}

- (void)readBody {
    uint8_t* bytes = self.buffer.mutableBytes + self.buffer.length - self.bytesRemaining;
    
    DLSStreamSize bytesRead = (DLSStreamSize)[self.stream read:bytes maxLength:self.bytesRemaining];
    self.bytesRemaining = self.bytesRemaining - bytesRead;
    if(self.bytesRemaining == 0) {
        NSData* buffer = self.buffer;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate streamReader:self receivedMessage:buffer];
        });
        [self prepareForHeader];
    }
}

- (void)readAvailableBytes {
    while(self.stream.hasBytesAvailable) {
        switch (self.readState) {
            case DLSBufferedStreamReaderStateReadingHeader:
                [self readHeader];
                break;
            case DLSBufferedStreamReaderStateReadingBody:
                [self readBody];
                break;
        }
    }
    if(self.stream.hasBytesAvailable) {
        [self readAvailableBytes];
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch(eventCode) {
        case NSStreamEventHasBytesAvailable:
            [self readAvailableBytes];
            break;
        case NSStreamEventEndEncountered:
        case NSStreamEventErrorOccurred: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate streamReaderClosed:self];
            });
            break;
        }
        case NSStreamEventNone:
        case NSStreamEventOpenCompleted:
        case NSStreamEventHasSpaceAvailable: {
            // do nothing
        }
    }
}

@end
