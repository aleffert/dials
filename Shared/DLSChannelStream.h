//
//  DLSChannelStream.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSChannelStream;
@class DLSChannel;

@protocol DLSChannelStreamDelegate

- (void)streamClosed:(DLSChannelStream*)stream;
- (void)stream:(DLSChannelStream*)stream receivedMessage:(NSData*)data onChannel:(DLSChannel*)channel;

@end

@interface DLSChannelStream : NSObject

- (id)initWithInputStream:(NSInputStream*)inputStream outputStream:(NSOutputStream*)outputStream;
- (id)initWithNetService:(NSNetService*)service;

@property (weak, nonatomic, nullable) id <DLSChannelStreamDelegate> delegate;

- (void)sendMessage:(NSData*)data onChannel:(DLSChannel*)channel;
- (void)close;

@end


NS_ASSUME_NONNULL_END
