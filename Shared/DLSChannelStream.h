//
//  DLSChannelStream.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSChannelStream;
@class DLSOwnedChannel;
@protocol DLSChannel;

@protocol DLSChannelStreamDelegate

- (void)streamClosed:(DLSChannelStream*)stream;
- (void)stream:(DLSChannelStream*)stream receivedMessage:(NSData*)data onChannel:(DLSOwnedChannel*)channel;

@end

@interface DLSChannelStream : NSObject

- (id)initWithInputStream:(NSInputStream*)inputStream outputStream:(NSOutputStream*)outputStream;
- (id)initWithNetService:(NSNetService*)service;

@property (weak, nonatomic) id delegate;

- (void)sendMessage:(NSData*)data onChannel:(id <DLSChannel>)channel;

@end
