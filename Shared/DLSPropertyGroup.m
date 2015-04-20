//
//  DLSDescriptionGroup.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/19/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSPropertyGroup.h"

#import "DLSConstants.h"

@implementation DLSPropertyGroup

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeObject(aDecoder, displayName);
        DLSDecodeObject(aDecoder, properties);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeObject(aCoder, displayName);
    DLSEncodeObject(aCoder, properties);
}

@end
