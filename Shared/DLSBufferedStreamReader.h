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

- (void)streamReader:(DLSBufferedStreamReader*)reader receivedMessage:(NSData*)data;
- (void)streamReaderClosed:(DLSBufferedStreamReader *)reader;

@end

@interface DLSBufferedStreamReader : NSObject

- (id)initWithInputStream:(NSInputStream*)stream;

@property (weak, nonatomic) id <DLSBufferedStreamReaderDelegate> delegate;

- (void)start;
- (void)close;

@end
