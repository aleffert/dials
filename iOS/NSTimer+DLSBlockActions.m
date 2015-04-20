//
//  NSTimer+DLSBlockActions.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/18/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "NSTimer+DLSBlockActions.h"

#import "DLSRemovable.h"

@interface DLSTimerListener : NSObject <DLSRemovable>

@property (copy, nonatomic) void(^action)(void);
@property (weak, nonatomic) NSTimer* timer;

@end

@implementation DLSTimerListener

- (void)timerFired:(NSTimer*)timer {
    if(self.action != nil) {
        self.action();
    }
    self.timer = nil;
}

- (void)remove {
    [self.timer invalidate];
    self.timer = nil;
    self.action = nil;
}

@end

@implementation NSTimer (DLSBlockActions)

+ (id <DLSRemovable>)dls_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats action:(void(^)(void))action {
    DLSTimerListener* listener = [[DLSTimerListener alloc] init];
    listener.action = action;
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:listener selector:@selector(timerFired:) userInfo:listener repeats:repeats];
    listener.timer = timer;
    return listener;
}


@end
