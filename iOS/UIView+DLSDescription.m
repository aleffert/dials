//
//  UIView+DLSDescribable.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//


#import "UIView+DLSDescribable.h"

#import "DLSDescriptionContext.h"
#import "DLSPropertyDescription.h"

@implementation UIView (DLSDescription)

- (void)dls_describe:(id <DLSDescriptionContext>)context {
    [context addGroupWithName:@"View"
                  properties: @[
                                DLSKeyPathProperty(@"alpha", [DLSSliderDescription zeroOneSlider]),
                                DLSKeyPathProperty(@"hidden", [DLSToggleDescription toggle])
                                 ]];
}

@end
