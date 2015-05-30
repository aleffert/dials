//
//  DLSBufferedStreamWriter.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSBufferedStreamWriter;

@protocol DLSBufferedStreamWriterDelegate <NSObject>

- (void)streamWriterClosed:(DLSBufferedStreamWriter*)writer;

@end

/// Simple class for wrapping up an NSOutputStream and buffering the results into discrete
/// messages.
@interface DLSBufferedStreamWriter : NSObject

- (id)initWithOutputStream:(NSOutputStream*)stream;

@property (weak, nonatomic, nullable) id <DLSBufferedStreamWriterDelegate> delegate;

- (void)open;
- (void)close;

- (void)enqueueMessage:(NSData*)data;

@end


NS_ASSUME_NONNULL_END
