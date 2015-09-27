//
//  UIView+DLSDescribable.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//


#import "UIView+DLSDescribable.h"

#import "DLSActionEditor.h"
#import "DLSColorEditor.h"
#import "DLSConstraintsEditor.h"
#import "DLSConstraintsExchanger.h"
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
    [context addGroupWithName:@"Constraints"
                   properties: @[
                                 DLSProperty(@"Constraints", [[DLSConstraintsEditor alloc] init])
                                 .setExchanger([[DLSConstraintsExchanger alloc] init])
                                 ]];
    [context addGroupWithName:@"View"
                   properties: @[
                                 DLSProperty(@"dials.controller", [DLSTextFieldEditor label]).setExchanger([[DLSViewControllerClassExchanger alloc] init]),
                                 DLSProperty(@"dials.triggerLayout", [[DLSActionEditor alloc] init]).setExchanger([[DLSTriggerLayoutExchanger alloc] init]),
                                 DLSProperty(@"backgroundColor", [DLSColorEditor editor]).setLabel(@"Background"),
                                 DLSProperty(@"tintColor", [DLSColorEditor editor]),
                                 DLSProperty(@"alpha", [DLSSliderEditor zeroOneSlider]),
                                 DLSProperty(@"hidden", [DLSToggleEditor editor]),
                                 DLSProperty(@"userInteractionEnabled", [DLSToggleEditor editor]),
                                 DLSProperty(@"frame", [[DLSRectEditor alloc] init]),
                                 DLSProperty(@"bounds", [[DLSRectEditor alloc] init]),
                                 DLSProperty(@"center", [[DLSPointEditor alloc] init]),
                                 DLSProperty(@"clipsToBounds", [DLSToggleEditor editor]),
                                 ]];
}

@end
