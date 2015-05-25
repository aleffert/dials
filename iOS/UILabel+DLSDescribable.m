//
//  UILabel+DLSViewAdjust.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "UILabel+DLSDescribable.h"

#import "DLSColorEditor.h"
#import "DLSDescriptionContext.h"
#import "DLSPropertyDescription.h"
#import "DLSStepperEditor.h"
#import "DLSTextFieldEditor.h"
#import "DLSToggleEditor.h"
#import "DLSValueMapper.h"
#import "UIView+DLSDescribable.h"

@implementation UILabel (DLSViewAdjust)

+ (void)dls_describe:(id<DLSDescriptionContext>)context {
    [super dls_describe:context];
    [context addGroupWithName:@"Label"
                   properties:@[
                                DLSProperty(@"text", [DLSTextFieldEditor textField]),
                                DLSProperty(@"textColor", [[DLSColorEditor alloc] init]),
                                DLSProperty(@"numberOfLines", [DLSTextFieldEditor textField]),
                                DLSProperty(@"adjustsFontSizeToFitWidth", [DLSTextFieldEditor textField]),
                                DLSProperty(@"preferredMaxLayoutWidth", [DLSStepperEditor editor]),
                                DLSProperty(@"enabled", [DLSToggleEditor editor]),
                                DLSProperty(@"highlighted", [DLSToggleEditor editor]),
                                // TODO: Make a font editor
                                DLSProperty(@"font.fontName", [DLSTextFieldEditor label]),
                                DLSProperty(@"font.pointSize", [DLSTextFieldEditor label]).composeMapper([[DLSNumericDescriptionMapper alloc] init]),
                                ]];
}

@end
