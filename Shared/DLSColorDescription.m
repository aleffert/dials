//
//  DLSColorDescription.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/21/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSColorDescription.h"

@implementation DLSColorDescription

+ (instancetype)editor {
    return [[DLSColorDescription alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    // no properties
    return [self init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // no properties
}

- (BOOL)canRevert {
    return YES;
}

@end
