//
//  DLSToggleEditor.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSToggleEditor.h"

@implementation DLSToggleEditor

+ (instancetype)editor {
    return [[[self class] alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // No properties
}

@end
