//
//  DLSSliderDescription.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSSliderDescription.h"

@interface DLSSliderDescription ()

@property (assign, nonatomic) CGFloat min;
@property (assign, nonatomic) CGFloat max;
@property (assign, nonatomic) BOOL continuous;

@end

@implementation DLSSliderDescription

+ (DLSSliderDescription*)zeroOneSlider {
    return [self sliderWithMin:0 max:1 continuous:YES];
}

+ (DLSSliderDescription*)sliderWithMin:(CGFloat)min max:(CGFloat)max continuous:(BOOL)continuous {
    DLSSliderDescription* description = [[DLSSliderDescription alloc] init];
    description.min = min;
    description.max = max;
    description.continuous = continuous;
    return description;
}

- (NSString*)identifier {
    return @"DLSSliderDescription";
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self != nil) {
        self.min = [aDecoder decodeFloatForKey:@"min"];
        self.max = [aDecoder decodeFloatForKey:@"max"];
        self.continuous = [aDecoder decodeBoolForKey:@"continuous"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeFloat:self.min forKey:@"min"];
    [aCoder encodeFloat:self.max forKey:@"max"];
    [aCoder encodeFloat:self.continuous forKey:@"continuous"];
}

@end
