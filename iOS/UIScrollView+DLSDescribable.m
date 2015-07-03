//
//  UIScrollView+DLSDescribable.m
//  Dials
//
//  Created by Akiva Leffert on 6/28/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "UIScrollView+DLSDescribable.h"

#import "DLSDescriptionContext.h"
#import "UIView+DLSDescribable.h"
#import "DLSFloatArrayEditor.h"
#import "DLSToggleEditor.h"

@implementation UIScrollView (DLSDescribable)

+ (void)dls_describe:(id<DLSDescriptionContext>)context {
    [super dls_describe:context];
    [context addGroupWithName:@"Scroll View"
                   properties:@[
                                DLSProperty(@"contentOffset", [[DLSPointEditor alloc] init]),
                                DLSProperty(@"contentSize", [[DLSSizeEditor alloc] init]),
                                DLSProperty(@"contentInset", [[DLSEdgeInsetsEditor alloc] init]),
                                DLSProperty(@"scrollIndicatorInsets", [[DLSEdgeInsetsEditor alloc] init]),
                                DLSProperty(@"bounces", [[DLSToggleEditor alloc] init]),
                                DLSProperty(@"alwaysBounceHorizontal", [[DLSToggleEditor alloc] init]),
                                DLSProperty(@"alwaysBounceVertical", [[DLSToggleEditor alloc] init]),
                                ]];
}

@end
