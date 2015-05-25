//
//  DLSColorEditor.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 3/21/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Dials/DLSEditor.h>

@interface DLSColorEditor : NSObject <DLSEditor>

/// Represents a color well
+ (instancetype)editor;

@end
