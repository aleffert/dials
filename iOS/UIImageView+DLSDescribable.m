//
//  UIImageView+DLSDescribable.m
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "UIImageView+DLSDescribable.h"

#import "DLSDescriptionContext.h"
#import "DLSImageEditor.h"
#import "DLSToggleEditor.h"

@implementation UIImageView (DLSDescribable)

+ (void)dls_describe:(id<DLSDescriptionContext>)context {
    [super dls_describe:context];
    [context addGroupWithName:@"Image"
                   properties:@[
                                DLSProperty(@"image", [DLSImageEditor editor]),
                                DLSProperty(@"highlightedImage", [DLSImageEditor editor]),
                                DLSProperty(@"highlighted", [DLSToggleEditor editor]),
                                ]];
}

@end
