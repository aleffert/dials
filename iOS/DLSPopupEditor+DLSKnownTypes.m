//
//  DLSPopupEditor+DLSKnownTypes.m
//  Dials
//
//  Created by Akiva Leffert on 5/29/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSPopupEditor+DLSKnownTypes.h"

@implementation DLSPopupEditor (DLSKnownTypes)

+ (instancetype)textAlignment {
    return [[self alloc]
            initWithPopupOptions:@[
                              [[DLSPopupOption alloc] initWithLabel:@"Left" value:@(NSTextAlignmentLeft)],
                              [[DLSPopupOption alloc] initWithLabel:@"Center" value:@(NSTextAlignmentCenter)],
                              [[DLSPopupOption alloc] initWithLabel:@"Right" value:@(NSTextAlignmentRight)],
                              [[DLSPopupOption alloc] initWithLabel:@"Natural" value:@(NSTextAlignmentNatural)],
                              ]];
}

@end
