//
//  DLSEditorDescription.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSTextFieldDescription.h"

#import "DLSConstants.h"

@interface DLSTextFieldDescription ()

@property (assign, nonatomic, getter=isEditable) BOOL editable;

@end

@implementation DLSTextFieldDescription

+ (instancetype)textField {
    DLSTextFieldDescription* editor = [[DLSTextFieldDescription alloc] init];
    editor.editable = YES;
    return editor;
}

+ (instancetype)label {
    DLSTextFieldDescription* editor = [[DLSTextFieldDescription alloc] init];
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
