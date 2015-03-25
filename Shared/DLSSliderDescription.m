//
//  DLSSliderDescription.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSSliderDescription.h"

@interface DLSSliderDescription ()

@property (assign, nonatomic) double min;
@property (assign, nonatomic) double max;

@end

@implementation DLSSliderDescription

+ (DLSSliderDescription*)zeroOneSlider {
    return [self sliderWithMin:0 max:1];
}

+ (DLSSliderDescription*)sliderWithMin:(double)min max:(double)max {
    DLSSliderDescription* description = [[DLSSliderDescription alloc] init];
    description.min = min;
    description.max = max;
    return description;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.min = [aDecoder decodeDoubleForKey:@"min"];
        self.max = [aDecoder decodeDoubleForKey:@"max"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:self.min forKey:@"min"];
    [aCoder encodeDouble:self.max forKey:@"max"];
}

- (BOOL)canRevert {
    return true;
}

@end
