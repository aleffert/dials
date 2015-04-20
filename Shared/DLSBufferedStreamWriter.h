//
//  DLSBufferedStreamWriter.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSBufferedStreamWriter;

@protocol DLSBufferedStreamWriterDelegate <NSObject>

- (void)streamWriterClosed:(DLSBufferedStreamWriter* __nonnull)writer;

@end

@interface DLSBufferedStreamWriter : NSObject

- (nonnull id)initWithOutputStream:(NSOutputStream* __nonnull)stream;

@property (weak, nonatomic, nullable) id <DLSBufferedStreamWriterDelegate> delegate;

- (void)open;
- (void)close;

- (void)enqueueMessage:(NSData* __nonnull)data;

@end
