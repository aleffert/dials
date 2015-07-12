//
//  DLSRemovable.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 7/12/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DLSRemovable.h"

@interface DLSBlockRemovable ()

@property (copy, nonatomic) void(^action)(void);

@end

@implementation DLSBlockRemovable

- (id)initWithRemoveAction:(void(^)(void))action {
    self = [super init];
    if(self != nil) {
        self.action = action;
    }
    return self;
}

- (void)remove {
    if(self.action != nil) {
        self.action();
        self.action = nil;
    }
}

@end