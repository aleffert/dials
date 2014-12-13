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

@property (strong, nonatomic) NSInputStream* stream;
@property (assign, nonatomic) DLSBufferedStreamReaderState readState;
@property (assign, nonatomic) DLSStreamSize bytesRemaining;
@property (strong, nonatomic) NSMutableData* buffer;

@end

@implementation DLSBufferedStreamReader

- (id)initWithInputStream:(NSInputStream *)stream {
    self = [super init];
    if(self != nil) {
        self.stream = stream;
        self.stream.delegate = self;
    }
    return self;
}

- (void)prepareForHeader {
    self.readState = DLSBufferedStreamReaderStateReadingHeader;
    self.bytesRemaining = sizeof(DLSStreamSize);
    self.buffer = [NSMutableData dataWithCapacity:self.bytesRemaining];
}

- (void)open {
    [self.stream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.stream open];
}

- (void)close {
    [self.stream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.stream close];
    self.stream = nil;
}

- (void)readHeader {
    NSInteger bytesRead = [self.stream read:self.buffer.mutableBytes maxLength:self.bytesRemaining];
    self.bytesRemaining = self.bytesRemaining - bytesRead;
    if(self.bytesRemaining == 0) {
        int64_t bodySize = 0;
        [self.buffer getBytes:&bodySize length:sizeof(bodySize)];
        self.bytesRemaining = CFSwapInt64BigToHost(bodySize);
        self.buffer = [NSMutableData dataWithCapacity:self.bytesRemaining];
        self.readState = DLSBufferedStreamReaderStateReadingBody;
    }
}

- (void)readBody {
    uint8_t* bytes = self.buffer.mutableBytes + self.buffer.length;
    
    NSInteger bytesRead = [self.stream read:bytes maxLength:self.bytesRemaining];
    self.bytesRemaining = self.bytesRemaining - bytesRead;
    if(self.bytesRemaining == 0) {
        [self.delegate streamReader:self receivedMessage:self.buffer];
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
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch(eventCode) {
        case NSStreamEventHasBytesAvailable:
            [self readAvailableBytes];
            break;
        case NSStreamEventEndEncountered:
        case NSStreamEventErrorOccurred:
            [self.delegate streamReaderClosed:self];
            break;
        case NSStreamEventNone:
        case NSStreamEventOpenCompleted:
        case NSStreamEventHasSpaceAvailable: {
            // do nothing
        }
    }
}

@end
