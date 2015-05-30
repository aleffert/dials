//
//  DLSBufferedStreamReader.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSBufferedStreamReader;

@protocol DLSBufferedStreamReaderDelegate <NSObject>

- (void)streamReader:(DLSBufferedStreamReader*)reader receivedMessage:(NSData*)data;
- (void)streamReaderClosed:(DLSBufferedStreamReader*)reader;

@end

/// Simple class for wrapping up an NSInputStream and buffering the results into discrete
/// messages.
@interface DLSBufferedStreamReader : NSObject

- (id)initWithInputStream:(NSInputStream*)stream;

@property (weak, nonatomic, nullable) id <DLSBufferedStreamReaderDelegate> delegate;

- (void)open;
- (void)close;

@end


NS_ASSUME_NONNULL_END
