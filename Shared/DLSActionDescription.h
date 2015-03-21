//
//  DLSActionDescription.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/15/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DLSEditorDescription.h"

@interface DLSActionDescription : NSObject <DLSEditorDescription>

+ (DLSActionDescription*)editor;

@end
