//
//  DLSActionEditor.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/15/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSActionEditor.h"

@implementation DLSActionEditor

+ (instancetype)editor {
    return [[[self class] alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    // no properties
    return [super init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // no properties
}

@end
