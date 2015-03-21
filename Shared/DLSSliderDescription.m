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
@property (assign, nonatomic) BOOL continuous;

@end

@implementation DLSSliderDescription

+ (DLSSliderDescription*)zeroOneSlider {
    return [self sliderWithMin:0 max:1 continuous:YES];
}

+ (DLSSliderDescription*)sliderWithMin:(double)min max:(double)max continuous:(BOOL)continuous {
    DLSSliderDescription* description = [[DLSSliderDescription alloc] init];
    description.min = min;
    description.max = max;
    description.continuous = continuous;
    return description;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.min = [aDecoder decodeDoubleForKey:@"min"];
        self.max = [aDecoder decodeDoubleForKey:@"max"];
        self.continuous = [aDecoder decodeBoolForKey:@"continuous"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:self.min forKey:@"min"];
    [aCoder encodeDouble:self.max forKey:@"max"];
    [aCoder encodeBool:self.continuous forKey:@"continuous"];
}

@end
