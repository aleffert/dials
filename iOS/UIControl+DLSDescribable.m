//
//  UIControl+DLSDescribable.m
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "UIControl+DLSDescribable.h"

#import "DLSDescriptionContext.h"
#import "DLSToggleEditor.h"
#import "UIView+DLSDescribable.h"

@implementation UIControl (DLSDescribable)

+ (void)dls_describe:(id<DLSDescriptionContext>)context {
    [super dls_describe:context];
    [context addGroupWithName:@"Control"
                   properties:@[
                                DLSProperty(@"enabled", [DLSToggleEditor editor]),
                                DLSProperty(@"selected", [DLSToggleEditor editor]),
                                DLSProperty(@"highlighted", [DLSToggleEditor editor]),
                                ]];
}

@end
