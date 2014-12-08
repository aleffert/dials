//
//  NSObject+DLSDeallocAction.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/7/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "NSObject+DLSDeallocAction.h"

#import <objc/runtime.h>

@interface DLSDeallocActionRunner : NSObject

@property (copy, nonatomic) void (^action)(void);

@end

@implementation DLSDeallocActionRunner

- (void)dealloc {
    if(self.action) {
        self.action();
    }
}

@end


@implementation NSObject (DLSDeallocAction)

- (void)performActionOnDealloc:(void(^)(void))action {
    DLSDeallocActionRunner* runner = [[DLSDeallocActionRunner alloc] init];
    runner.action = action;
    @synchronized(self) {
        objc_setAssociatedObject(runner, (__bridge void*)runner, runner, OBJC_ASSOCIATION_RETAIN);
    }
}

@end
