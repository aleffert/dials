//
//  UISwitch+DLSDescribable.m
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "UISwitch+DLSDescribable.h"

#import "DLSColorEditor.h"
#import "DLSDescriptionContext.h"
#import "DLSToggleEditor.h"
#import "UIView+DLSDescribable.h"

@implementation UISwitch (DLSDescribable)

+ (void)dls_describe:(id<DLSDescriptionContext>)context {
    [super dls_describe:context];
    [context addGroupWithName:@"Switch"
                   properties:@[
                                DLSProperty(@"onTintColor", [DLSColorEditor editor]),
                                DLSProperty(@"thumbTintColor", [DLSColorEditor editor]),
                                DLSProperty(@"on", [DLSToggleEditor editor]),
                                ]];
}

@end
