//
//  DLSTextFieldEditor.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Dials/DLSEditor.h>

@interface DLSTextFieldEditor : NSObject <DLSEditor, NSCoding>

/// Represents an editable text field
+ (instancetype)textField;

/// Represents a read only label
+ (instancetype)label;

@property (readonly, nonatomic, getter=isEditable) BOOL editable;

@end
