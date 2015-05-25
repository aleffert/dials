//
//  DLSStepperEditor.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/20/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "DLSStepperEditor.h"

#import "DLSConstants.h"

@implementation DLSStepperEditor

+ (DLSStepperEditor*)editor {
    return [[DLSStepperEditor alloc] init];
}

- (id)init {
    self = [super init];
    if(self != nil) {
        self.min = 0;
        self.max = FLT_MAX;
        self.increment = 1;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self != nil) {
        DLSDecodeDouble(aDecoder, min);
        DLSDecodeDouble(aDecoder, max);
        DLSDecodeDouble(aDecoder, increment);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    DLSEncodeDouble(aCoder, min);
    DLSEncodeDouble(aCoder, max);
    DLSEncodeDouble(aCoder, increment);
}

@end
