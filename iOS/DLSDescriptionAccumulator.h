//
//  DLSDescriptionAccumulator.h
//  Dials
//
//  Created by Akiva Leffert on 5/30/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DLSDescriptionContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface DLSDescriptionAccumulator : NSObject <DLSDescriptionContext>

/// Array of DLSDescriptionGroup
@property (readonly, nonatomic) NSArray* groups;

@end


NS_ASSUME_NONNULL_END
