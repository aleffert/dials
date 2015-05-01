//
//  DLSEditorDescription.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 5/1/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DLSEditorDescription.h"

@interface DLSTextFieldDescription : NSObject <DLSEditorDescription, NSCoding>

+ (instancetype)textField;
+ (instancetype)label;

@end
