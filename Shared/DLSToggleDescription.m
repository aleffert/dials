//
//  DLSToggleDescription.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSToggleDescription.h"

@implementation DLSToggleDescription

+ (instancetype)editor {
    return [[DLSToggleDescription alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // No properties
}

- (BOOL)readOnly {
    return true;
}

@end
