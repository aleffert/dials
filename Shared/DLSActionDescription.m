//
//  DLSActionDescription.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/15/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSActionDescription.h"

@implementation DLSActionDescription

+ (DLSActionDescription*)editor {
    return [[DLSActionDescription alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    // no properties
    return [super init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // no properties
}

- (BOOL)canRevert {
    return NO;
}

@end
