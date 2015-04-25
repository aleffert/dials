//
//  DLSTransform3D.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSTransform3D.h"

@implementation DLSTransform3D

- (id)initWithTransform:(CATransform3D)transform {
    if(self != nil) {
        _transform = transform;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        for(NSString* key in [self keys]) {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    for(NSString* key in [self keys]) {
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

- (NSArray*)keys {
    static dispatch_once_t onceToken;
    static NSArray* keys = nil;
    dispatch_once(&onceToken, ^{
        keys = @[
            @"m11", @"m12", @"m13", @"m14",
            @"m21", @"m22", @"m23", @"m24",
            @"m31", @"m32", @"m33", @"m34",
            @"m41", @"m42", @"m43", @"m44"
          ];
    });
    return keys;
}

@end
