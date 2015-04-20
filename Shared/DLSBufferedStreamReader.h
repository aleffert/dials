//
//  DLSBufferedStreamReader.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSBufferedStreamReader;

@protocol DLSBufferedStreamReaderDelegate <NSObject>

- (void)streamReader:(DLSBufferedStreamReader* __nonnull)reader receivedMessage:(NSData* __nonnull)data;
- (void)streamReaderClosed:(DLSBufferedStreamReader* __nonnull)reader;

@end

@interface DLSBufferedStreamReader : NSObject

- (nonnull id)initWithInputStream:(NSInputStream* __nonnull)stream;

@property (weak, nonatomic, nullable) id <DLSBufferedStreamReaderDelegate> delegate;

- (void)open;
- (void)close;

@end
