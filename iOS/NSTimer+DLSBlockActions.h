//
//  NSTimer+DLSBlockActions.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/18/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DLSRemovable;

@interface NSTimer (DLSBlockActions)

+ (nonnull id <DLSRemovable>)dls_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats action:(void(^ __nonnull)(void))action;

@end


NS_ASSUME_NONNULL_END
