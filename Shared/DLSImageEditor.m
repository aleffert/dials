//
//  DLSImageEditor.m
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSImageEditor.h"

@implementation DLSImageEditor

+ (instancetype)editor {
    return [[[self class] alloc] init];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [super init];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // Nothing to do
}

@end
