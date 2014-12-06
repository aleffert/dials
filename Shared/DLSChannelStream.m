//
//  DLSChannelStream.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSChannelStream.h"

#import "DLSBufferedStreamReader.h"
#import "DLSBufferedStreamWriter.h"

@interface DLSChannelStream () <DLSBufferedStreamReaderDelegate, DLSBufferedStreamWriterDelegate>

@property (strong, nonatomic) DLSBufferedStreamReader* streamReader;
@property (strong, nonatomic) DLSBufferedStreamWriter* streamWriter;

@property (strong, nonatomic) NSData* currentHeader;

@end

@implementation DLSChannelStream

- (id)initWithNetService:(NSNetService*)service {
    NSInputStream* inputStream;
    NSOutputStream* outputStream;
    [service getInputStream:&inputStream outputStream:&outputStream];
    return [self initWithInputStream:inputStream outputStream:outputStream];
}

- (id)initWithInputStream:(NSInputStream*)inputStream outputStream:(NSOutputStream*)outputStream {
    self = [super init];
    if(self != nil) {
        self.streamReader = [[DLSBufferedStreamReader alloc] initWithInputStream:inputStream];
        self.streamReader.delegate = self;
        self.streamWriter = [[DLSBufferedStreamWriter alloc] initWithOutputStream:outputStream];
        self.streamWriter.delegate = self;
    }
    return self;
}

- (void)sendMessage:(NSData *)data onChannel:(id<DLSChannel>)channel {
    [self.streamWriter enqueueMessage:[NSKeyedArchiver archivedDataWithRootObject:channel]];
    [self.streamWriter enqueueMessage:data];
}

- (void)streamReader:(DLSBufferedStreamReader *)reader receivedMessage:(NSData *)data {
    if(self.currentHeader == nil) {
        self.currentHeader = data;
    }
    else {
        DLSOwnedChannel* channel = [NSKeyedUnarchiver unarchiveObjectWithData:self.currentHeader];
        [self.delegate stream:self receivedMessage:data onChannel:channel];
        self.currentHeader = nil;
    }
}

- (void)streamWriterClosed:(DLSBufferedStreamWriter *)writer {
    [self.streamReader close];
    self.streamReader = nil;
    self.streamReader.delegate = nil;
    self.streamWriter = nil;
    self.streamWriter.delegate = nil;
    [self.delegate streamClosed:self];
}

- (void)streamReaderClosed:(DLSBufferedStreamReader *)reader {
    [self.streamWriter close];
    self.streamReader = nil;
    self.streamReader.delegate = nil;
    self.streamWriter = nil;
    self.streamWriter.delegate = nil;
    [self.delegate streamClosed:self];
}

@end
