//
//  DLSOptionEditor+DLSKnownTypes.m
//  Dials
//
//  Created by Akiva Leffert on 5/29/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSOptionEditor+DLSKnownTypes.h"

@implementation DLSOptionEditor (DLSKnownTypes)

+ (instancetype)textAlignment {
    return [[self alloc]
            initWithOptionItems:@[
                              [[DLSOptionItem alloc] initWithLabel:@"Left" value:@(NSTextAlignmentLeft)],
                              [[DLSOptionItem alloc] initWithLabel:@"Center" value:@(NSTextAlignmentCenter)],
                              [[DLSOptionItem alloc] initWithLabel:@"Right" value:@(NSTextAlignmentRight)],
                              [[DLSOptionItem alloc] initWithLabel:@"Natural" value:@(NSTextAlignmentNatural)],
                              ]];
}

@end
