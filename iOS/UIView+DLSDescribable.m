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
#import "DLSValueExchanger.h"

@implementation UIView (DLSDescribable)

+ (id <DLSValueExchanger>)dls_valueExchangerForProperty:(NSString*)property inGroup:(NSString*)group {
    id <DLSValueExchanger> exchanger = [DLSKeyPathExchanger keyPathExchangerWithKeyPath:property];
    if([property isEqualToString:@"layer.borderColor"]) {
        return [[DLSCGColorCoercionExchanger alloc] initWithBackingExchanger:exchanger];
    }
    else if([property isEqualToString:@"dials.controller"]) {
        return [[DLSViewControllerClassExchanger alloc] init];
    }
    return exchanger;
}

+ (void)dls_describe:(id <DLSDescriptionContext>)context {
    [context addGroupWithName:@"Layer"
                   properties: @[
                                 DLSDisplayProperty(@"Corner Radius", @"layer.cornerRadius", [DLSStepperDescription editor]),
                                 DLSDisplayProperty(@"Border Width", @"layer.borderWidth", [DLSStepperDescription editor]),
                                 DLSDisplayProperty(@"Border Color", @"layer.borderColor", [DLSColorDescription editor]),
                                 ]];
    [context addGroupWithName:@"View"
                   properties: @[
                                 DLSDisplayProperty(@"Controller", @"dials.controller", [DLSTextFieldDescription label]),
                                 DLSProperty(@"alpha", [DLSSliderDescription zeroOneSlider]),
                                 DLSProperty(@"hidden", [DLSToggleDescription editor]),
                                 DLSProperty(@"clipsToBounds", [DLSToggleDescription editor]),
                                 DLSDisplayProperty(@"Background", @"backgroundColor", [DLSColorDescription editor])
                                 ]];
}

@end
