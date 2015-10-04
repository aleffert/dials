//
//  DLSSourceLocation.h
//  Dials
//
//  Created by Akiva Leffert on 10/3/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DLSSourceLocation <NSCoding>

@property (readonly, copy, nonatomic) NSString* file;
@property (readonly, assign, nonatomic) NSUInteger line;

@end

NS_ASSUME_NONNULL_END
