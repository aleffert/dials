//
//  DLSSliderDescription.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSSliderDescription.h"

#import "DLSConstants.h"

@interface DLSSliderDescription ()

@property (assign, nonatomic) double min;
@property (assign, nonatomic) double max;

@end

@implementation DLSSliderDescription

+ (DLSSliderDescription*)zeroOneSlider {
    return [self sliderWithMin:0 max:1];
}

+ (DLSSliderDescription*)sliderWithMin:(double)min max:(double)max {
    DLSSliderDescription* description = [[DLSSliderDescription alloc] initWithMin:min max:max];
    return description;
}

- (id)initWithMin:(double)min max:(double)max {
    self = [super init];
    if(self != nil) {
        self.min = min;
        self.max = max;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        DLSDecodeDouble(aDecoder, min);
        DLSDecodeDouble(aDecoder, max);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeDouble(aCoder, min);
    DLSEncodeDouble(aCoder, max);
}

- (BOOL)readOnly {
    return true;
}

@end
