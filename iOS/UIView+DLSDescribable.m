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

- (id <DLSValueExchanger>)dls_valueExchangerForProperty:(NSString*)property inGroup:(NSString*)group {
    id <DLSValueExchanger> exchanger = [DLSKeyPathExchanger keyPathExchangerWithKeyPath:property];
    if([property isEqualToString:@"layer.borderColor"]) {
        return [[DLSCGColorCoercionExchanger alloc]initWithBackingExchanger:exchanger];
    }
    return exchanger;
}

- (void)dls_describe:(id <DLSDescriptionContext>)context {
    [context addGroupWithName:@"View"
                  properties: @[
                                DLSProperty(@"alpha", [DLSSliderDescription zeroOneSlider]),
                                DLSProperty(@"hidden", [DLSToggleDescription editor]),
                                DLSProperty(@"backgroundColor", [DLSColorDescription editor])
                                 ]];
    
    [context addGroupWithName:@"Layer"
                   properties: @[
                                 DLSProperty(@"layer.cornerRadius", [DLSStepperDescription editor]),
                                 DLSProperty(@"layer.borderWidth", [DLSStepperDescription editor]),
                                 DLSProperty(@"layer.borderColor", [DLSColorDescription editor]),
                                 ]];
}

@end
