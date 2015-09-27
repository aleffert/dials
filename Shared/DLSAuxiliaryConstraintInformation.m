//
//  DLSAuxiliaryConstraintInformation.m
//  Dials
//
//  Created by Akiva Leffert on 9/27/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import "DLSAuxiliaryConstraintInformation.h"

@interface DLSAuxiliaryConstraintInformation ()

@property (copy, nonatomic) NSString* identifier;
@property (strong, nonatomic) id <NSCoding> userData;

@end

@implementation DLSAuxiliaryConstraintInformation

- (id)initWithPluginIdentifier:(NSString*)identifier userData:(id <NSCoding>)userData {
    self = [super init];
    if(self != nil) {
        self.identifier = identifier;
        self.userData = userData;
    }
    return self;
}

@end
