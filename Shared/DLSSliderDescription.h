//
//  DLSSliderDescription.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#import <Dials/DLSEditorDescription.h>

@interface DLSSliderDescription : NSObject <DLSEditorDescription>

+ (DLSSliderDescription*)zeroOneSlider;
+ (DLSSliderDescription*)sliderWithMin:(double)min max:(double)max;

- (id)initWithMin:(double)min max:(double)max;

@property (readonly, assign, nonatomic) double min;
@property (readonly, assign, nonatomic) double max;

@end
