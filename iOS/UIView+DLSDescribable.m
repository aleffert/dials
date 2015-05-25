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
                                 DLSProperty(@"layer.cornerRadius", [DLSStepperEditor editor]).setLabel(@"Corner Radius"),
                                 DLSProperty(@"layer.borderWidth", [DLSStepperEditor editor]).setLabel(@"Border Width"),
                                 DLSProperty(@"layer.borderColor", [DLSColorEditor editor]).setLabel(@"Border Color").composeMapper([[DLSCGColorMapper alloc] init])
                                 ]];
    [context addGroupWithName:@"View"
                   properties: @[
                                 DLSProperty(@"dials.controller", [DLSTextFieldEditor label]).setLabel(@"Controller").setExchanger([[DLSViewControllerClassExchanger alloc] init]),
                                 DLSProperty(@"alpha", [DLSSliderEditor zeroOneSlider]),
                                 DLSProperty(@"hidden", [DLSToggleEditor editor]),
                                 DLSProperty(@"bounds", [[DLSRectEditor alloc] init]).composeMapper([[DLSRectMapper alloc] init]),
                                 DLSProperty(@"frame", [[DLSRectEditor alloc] init]).composeMapper([[DLSRectMapper alloc] init]),
                                 DLSProperty(@"clipsToBounds", [DLSToggleEditor editor]),
                                 DLSProperty(@"backgroundColor", [DLSColorEditor editor]).setLabel(@"Background")
                                 ]];
}

@end
