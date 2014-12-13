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

- (void)streamWriterClosed:(DLSBufferedStreamWriter*)writer;

@end

@interface DLSBufferedStreamWriter : NSObject

- (id)initWithOutputStream:(NSOutputStream*)stream;

@property (weak, nonatomic) id <DLSBufferedStreamWriterDelegate> delegate;

- (void)open;
- (void)close;

- (void)enqueueMessage:(NSData*)data;

@end
