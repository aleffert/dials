//
//  UIButton+DLSDescribable.m
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "UIButton+DLSDescribable.h"

#import "DLSDescriptionContext.h"
#import "DLSFloatArrayEditor.h"
#import "DLSToggleEditor.h"
#import "UIView+DLSDescribable.h"

@implementation UIButton (DLSDescribable)

+ (void)dls_describe:(id<DLSDescriptionContext>)context {
    [super dls_describe:context];
    [context addGroupWithName:@"Button"
                   properties:@[
                                DLSProperty(@"imageEdgeInsets", [[DLSEdgeInsetsEditor alloc] init]),
                                DLSProperty(@"titleEdgeInsets", [[DLSEdgeInsetsEditor alloc] init]),
                                DLSProperty(@"contentEdgeInsets", [[DLSEdgeInsetsEditor alloc] init]),
                                DLSProperty(@"adjustsImageWhenHighlighted", [[DLSToggleEditor alloc] init]),
                                DLSProperty(@"adjustsImageWhenDisabled", [[DLSToggleEditor alloc] init]),
                                DLSProperty(@"showsTouchWhenHighlighted", [[DLSToggleEditor alloc] init]),
                                ]];
}

@end
