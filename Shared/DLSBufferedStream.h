//
//  DLSBufferedStream.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef int64_t DLSStreamSize;

@class DLSBufferedStream;

@protocol DLSBufferedStreamDelegate

- (void)streamClosed:(DLSBufferedStream*)stream;
- (void)stream:(DLSBufferedStream*)stream receivedMessage:(NSData*)data;

@end

@interface DLSBufferedStream : NSObject

- (id)initWithInputStream:(NSInputStream*)inputStream outputStream:(NSOutputStream*)outputStream;
- (id)initWithNetService:(NSNetService*)service;

@property (weak, nonatomic) id delegate;

- (void)sendMessage:(NSData*)data;

@end
