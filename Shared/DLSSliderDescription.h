//
//  DLSSliderDescription.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#import "DLSTypeDescription.h"

@interface DLSSliderDescription : NSObject <DLSTypeDescription>

+ (DLSSliderDescription*)zeroOneSlider;
+ (DLSSliderDescription*)sliderWithMin:(CGFloat)min max:(CGFloat)max continuous:(BOOL)continuous;

@property (readonly, assign, nonatomic) CGFloat min;
@property (readonly, assign, nonatomic) CGFloat max;
@property (readonly, assign, nonatomic) BOOL continuous;

@end
