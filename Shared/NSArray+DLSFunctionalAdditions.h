//
//  NSArray+DLSFunctionalAdditions.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DLSFunctionalAdditions)

/// Returns an array by applying a functional to every element of an array
/// If the function returns nil, that item is ignored
- (NSArray*)dls_map:(id(^)(id o))mapper;

@end