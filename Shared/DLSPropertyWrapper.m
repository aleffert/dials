//
//  DLSPropertyWrapper.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSPropertyWrapper.h"

@implementation DLSPropertyWrapper

- (id)initWithGetter:(id (^)(void))getter setter:(void(^)(id))setter {
    self = [super init];
    if(self != nil) {
        self.getter = getter;
        self.setter = setter;
    }
    return self;
}

@end