//
//  UISlider+DLSDescribable.m
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "UISlider+DLSDescribable.h"

#import "DLSColorEditor.h"
#import "DLSDescriptionContext.h"
#import "DLSStepperEditor.h"
#import "DLSToggleEditor.h"
#import "UIView+DLSDescribable.h"

@implementation UISlider (DLSDescribable)

+ (void)dls_describe:(id<DLSDescriptionContext>)context {
    [super dls_describe:context];
    [context addGroupWithName:@"Slider"
                   properties:@[
                                DLSProperty(@"value", [[DLSStepperEditor alloc] init]),
                                DLSProperty(@"minimumValue", [DLSStepperEditor editor]).setLabel(@"Minimum"),
                                DLSProperty(@"maximuValue", [DLSStepperEditor editor]).setLabel(@"Maximum"),
                                DLSProperty(@"continuous", [DLSToggleEditor editor]),
                                DLSProperty(@"minimumTrackTintColor", [DLSColorEditor editor]).setLabel(@"Min Track Color"),
                                DLSProperty(@"maximumTrackTintColor", [DLSColorEditor editor]).setLabel(@"Max Track Color"),
                                ]];
}

@end
