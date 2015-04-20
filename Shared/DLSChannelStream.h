//
//  DLSChannelStream.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSChannelStream;
@class DLSChannel;

@protocol DLSChannelStreamDelegate

- (void)streamClosed:(DLSChannelStream* __nonnull)stream;
- (void)stream:(DLSChannelStream* __nonnull)stream receivedMessage:(NSData* __nonnull)data onChannel:(DLSChannel* __nonnull)channel;

@end

@interface DLSChannelStream : NSObject

- (nonnull id)initWithInputStream:(NSInputStream* __nonnull)inputStream outputStream:(NSOutputStream* __nonnull)outputStream;
- (nonnull id)initWithNetService:(NSNetService* __nonnull)service;

@property (weak, nonatomic, nullable) id <DLSChannelStreamDelegate> delegate;

- (void)sendMessage:(NSData* __nonnull)data onChannel:(DLSChannel* __nonnull)channel;
- (void)close;

@end
