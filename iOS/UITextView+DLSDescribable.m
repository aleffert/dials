//
//  UITextView+DLSDescribable.m
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "UITextView+DLSDescribable.h"

#import "DLSDescriptionContext.h"
#import "DLSTextFieldEditor.h"
#import "DLSToggleEditor.h"
#import "DLSValueMapper.h"

@implementation UITextView (DLSDescribable)

+ (void)dls_describe:(id<DLSDescriptionContext>)context {
    [super dls_describe:context];
    [context addGroupWithName:@"Text View"
                   properties:@[
                                DLSProperty(@"text", [DLSTextFieldEditor textField]),
                                DLSProperty(@"font.fontName", [DLSTextFieldEditor label]),
                                DLSProperty(@"font.pointSize", [DLSTextFieldEditor label]).composeMapper([[DLSNumericDescriptionMapper alloc] init]),
                                DLSProperty(@"editable", [DLSToggleEditor editor]),
                                DLSProperty(@"selectable", [DLSToggleEditor editor]),
                                ]];
}

@end
