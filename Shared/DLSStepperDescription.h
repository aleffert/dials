//
//  DLSStepperDescription.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/20/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Dials/DLSEditorDescription.h>

@interface DLSStepperDescription : NSObject <DLSEditorDescription>

// defaults to zero -> inf, increment:1
+ (DLSStepperDescription*)editor;

@property (assign, nonatomic) double min;
@property (assign, nonatomic) double max;
@property (assign, nonatomic) double increment;

@end
