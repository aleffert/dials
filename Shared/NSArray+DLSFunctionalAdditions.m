//
//  NSArray+DLSFunctionalAdditions.m
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "NSArray+DLSFunctionalAdditions.h"

@implementation NSArray (DLSFunctionalAdditions)

- (NSArray*)dls_map:(id (^)(id o))mapper {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for(id item in self) {
        id mapped = mapper(item);
        if(mapped != nil) {
            [result addObject:mapped];
        }
    }
    return result;
}

@end
