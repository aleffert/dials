//
//  UILabel+DLSViewAdjust.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "UILabel+DLSViewAdjust.h"

#import "UIView+DLSDescribable.h"
#import "DLSDescriptionContext.h"

@implementation UILabel (DLSViewAdjust)

+ (void)dls_describe:(id<DLSDescriptionContext>)context {
    [super dls_describe:context];
    [context addGroupWithName:@"Label" properties:@[
                                                    DLSProperty(@"text", [DLSTextFieldDescription textField])
                                                    ]];
}

@end
