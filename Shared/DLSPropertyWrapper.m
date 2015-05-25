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

- (id)initWithKeyPath:(NSString*)keyPath object:(id)object {
    __weak id owner = object;
    return [self initWithGetter:^id  {
        return [owner valueForKeyPath:keyPath];
    } setter:^(id value) {
        [owner setValue:value forKeyPath:keyPath];
    }];
}

- (instancetype)composeWithGetterMap:(id (^)(id))getterMap setterMap:(id(^)(id))setterMap {
    return [[DLSPropertyWrapper alloc] initWithGetter:^id {
        return getterMap(self.getter());
    } setter:^(id value) {
        self.setter(setterMap(value));
    }];
}

@end