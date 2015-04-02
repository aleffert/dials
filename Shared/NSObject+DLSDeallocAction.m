//
//  NSObject+DLSDeallocAction.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 12/7/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "NSObject+DLSDeallocAction.h"

#import "DLSRemovable.h"
#import <objc/runtime.h>

@interface DLSDeallocActionRunner : NSObject <DLSRemovable>

@property (copy, nonatomic) void (^action)(void);
@property (copy, nonatomic) void (^removeAction)(DLSDeallocActionRunner* caller);

@end

@implementation DLSDeallocActionRunner

- (void)dealloc {
    if(self.action) {
        self.action();
    }
}

- (void)remove {
    self.action = nil;
    if(self.removeAction) {
        self.removeAction(self);
    }
    self.removeAction = nil;
}

@end


@implementation NSObject (DLSDeallocAction)

- (id <DLSRemovable>)dls_performActionOnDealloc:(void(^)(void))action {
    DLSDeallocActionRunner* runner = [[DLSDeallocActionRunner alloc] init];
    runner.action = action;
    __weak __typeof(self) weakself = self;
    runner.removeAction = ^(DLSDeallocActionRunner* caller){
        objc_setAssociatedObject(weakself, (__bridge void*)caller, nil, OBJC_ASSOCIATION_RETAIN);
    };
    
    objc_setAssociatedObject(self, (__bridge void*)runner, runner, OBJC_ASSOCIATION_RETAIN);
    return runner;
}

@end
