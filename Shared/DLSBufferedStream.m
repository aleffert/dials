//
//  DLSBufferedStream.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "DLSBufferedStream.h"

#import "DLSBufferedStreamReader.h"
#import "DLSBufferedStreamWriter.h"

@interface DLSBufferedStream () <DLSBufferedStreamReaderDelegate, DLSBufferedStreamWriterDelegate>

@property (strong, nonatomic) DLSBufferedStreamReader* streamReader;
@property (strong, nonatomic) DLSBufferedStreamWriter* streamWriter;

@end

@implementation DLSBufferedStream

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

- (void)sendMessage:(NSData *)data {
    [self.streamWriter enqueueMessage:data];
}

- (void)streamReader:(DLSBufferedStreamReader *)reader receivedMessage:(NSData *)data {
    [self.delegate stream:self receivedMessage:data];
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
