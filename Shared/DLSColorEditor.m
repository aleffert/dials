//
//  DLSColorEditor.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/21/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSColorEditor.h"

@implementation DLSColorEditor

+ (instancetype)editor {
    return [[[self class] alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    // no properties
    return [self init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // no properties
}

@end


@implementation DLSCGColorEditor

@end