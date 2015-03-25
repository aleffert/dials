//
//  basic-before.m
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

#import <Dials/Dials.h>

static BOOL SomeBoolean = YES;
static CGFloat SomeFloat = 10;

@interface SomeClass : NSObject

@end

@implementation SomeClass

- (void)viewDidLoad {
    DLSAddToggleControl(@"Description", SomeBoolean)
    DLSAddSliderControl( @"Other Content" , SomeFloat, 0, 1, false)
}

@end
