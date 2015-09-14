//
//  DLSPropertyGroup.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/19/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSPropertyDescription;

@interface DLSPropertyGroup : NSObject <NSCoding>

@property (copy, nonatomic, nonnull) NSString* label;
@property (copy, nonatomic, nonnull) NSArray<DLSPropertyDescription*>* properties;

@end

NS_ASSUME_NONNULL_END
