//
//  DLSToggleEditor.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/14/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Dials/DLSEditor.h>

@interface DLSToggleEditor : NSObject <DLSEditor>

/// Represents a togglable check box
+ (instancetype)editor;

@end
