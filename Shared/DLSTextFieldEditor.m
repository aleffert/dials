//
//  DLSTextFieldEditor.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSTextFieldEditor.h"

#import "DLSConstants.h"

@interface DLSTextFieldEditor ()

@property (assign, nonatomic, getter=isEditable) BOOL editable;

@end

@implementation DLSTextFieldEditor

+ (instancetype)textField {
    DLSTextFieldEditor* editor = [[DLSTextFieldEditor alloc] init];
    editor.editable = YES;
    return editor;
}

+ (instancetype)label {
    DLSTextFieldEditor* editor = [[DLSTextFieldEditor alloc] init];
    editor.editable = NO;
    return editor;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeBool(aDecoder, editable);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeBool(aCoder, editable);
}

@end
