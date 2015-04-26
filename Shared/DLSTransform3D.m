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
        _transform.m11 = [aDecoder decodeFloatForKey:@"m11"];
        _transform.m12 = [aDecoder decodeFloatForKey:@"m12"];
        _transform.m13 = [aDecoder decodeFloatForKey:@"m13"];
        _transform.m14 = [aDecoder decodeFloatForKey:@"m14"];
        _transform.m21 = [aDecoder decodeFloatForKey:@"m21"];
        _transform.m22 = [aDecoder decodeFloatForKey:@"m22"];
        _transform.m23 = [aDecoder decodeFloatForKey:@"m23"];
        _transform.m24 = [aDecoder decodeFloatForKey:@"m24"];
        _transform.m31 = [aDecoder decodeFloatForKey:@"m31"];
        _transform.m32 = [aDecoder decodeFloatForKey:@"m32"];
        _transform.m33 = [aDecoder decodeFloatForKey:@"m33"];
        _transform.m34 = [aDecoder decodeFloatForKey:@"m34"];
        _transform.m41 = [aDecoder decodeFloatForKey:@"m41"];
        _transform.m42 = [aDecoder decodeFloatForKey:@"m42"];
        _transform.m43 = [aDecoder decodeFloatForKey:@"m43"];
        _transform.m44 = [aDecoder decodeFloatForKey:@"m44"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeFloat:self.transform.m11 forKey:@"m11"];
    [aCoder encodeFloat:self.transform.m12 forKey:@"m12"];
    [aCoder encodeFloat:self.transform.m13 forKey:@"m13"];
    [aCoder encodeFloat:self.transform.m14 forKey:@"m14"];
    [aCoder encodeFloat:self.transform.m21 forKey:@"m21"];
    [aCoder encodeFloat:self.transform.m22 forKey:@"m22"];
    [aCoder encodeFloat:self.transform.m23 forKey:@"m23"];
    [aCoder encodeFloat:self.transform.m24 forKey:@"m24"];
    [aCoder encodeFloat:self.transform.m31 forKey:@"m31"];
    [aCoder encodeFloat:self.transform.m32 forKey:@"m32"];
    [aCoder encodeFloat:self.transform.m33 forKey:@"m33"];
    [aCoder encodeFloat:self.transform.m34 forKey:@"m34"];
    [aCoder encodeFloat:self.transform.m41 forKey:@"m41"];
    [aCoder encodeFloat:self.transform.m42 forKey:@"m42"];
    [aCoder encodeFloat:self.transform.m43 forKey:@"m43"];
    [aCoder encodeFloat:self.transform.m44 forKey:@"m44"];
}

@end
