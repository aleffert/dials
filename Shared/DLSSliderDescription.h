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

/// Represents a continuous slider for zero to one
+ (DLSSliderDescription*)zeroOneSlider;

/// Represents a continuous slider with the given min and max
/// @param min The mininum value the slider can take
/// @param max The maximum value the slider can take
+ (DLSSliderDescription*)sliderWithMin:(double)min max:(double)max;

/// Represents a continuous slider with the given min and max
/// @param min The mininum value the slider can take
/// @param max The maximum value the slider can take
- (id)initWithMin:(double)min max:(double)max;

/// @param min The mininum value the slider can take
@property (readonly, assign, nonatomic) double min;

/// @param max The maximum value the slider can take
@property (readonly, assign, nonatomic) double max;

@end
