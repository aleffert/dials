//
//  UIView+DLSDescribable.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//


#import "UIView+DLSDescribable.h"

#import "DLSColorEditor.h"
#import "DLSDescriptionContext.h"
#import "DLSFloatArrayEditor.h"
#import "DLSPropertyDescription.h"
#import "DLSSliderEditor.h"
#import "DLSStepperEditor.h"
#import "DLSTextFieldEditor.h"
#import "DLSToggleEditor.h"
#import "DLSValueExchanger.h"

@implementation UIView (DLSDescribable)

+ (void)dls_describe:(id <DLSDescriptionContext>)context {
    [context addGroupWithName:@"Layer"
                   properties: @[
                                 DLSProperty(@"layer.cornerRadius", [DLSStepperEditor editor]),
                                 DLSProperty(@"layer.borderWidth", [DLSStepperEditor editor]),
                                 DLSProperty(@"layer.borderColor", [DLSCGColorEditor editor])
                                 ]];
    [context addGroupWithName:@"View"
                   properties: @[
                                 DLSProperty(@"dials.controller", [DLSTextFieldEditor label]).setExchanger([[DLSViewControllerClassExchanger alloc] init]),
                                 DLSProperty(@"alpha", [DLSSliderEditor zeroOneSlider]),
                                 DLSProperty(@"hidden", [DLSToggleEditor editor]),
                                 DLSProperty(@"bounds", [[DLSRectEditor alloc] init]),
                                 DLSProperty(@"frame", [[DLSRectEditor alloc] init]),
                                 DLSProperty(@"clipsToBounds", [DLSToggleEditor editor]),
                                 DLSProperty(@"backgroundColor", [DLSColorEditor editor]).setLabel(@"Background")
                                 ]];
}

@end
