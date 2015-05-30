//
//  DLSTransform3D.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 4/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSTransform3D : NSObject <NSCoding>

- (id)initWithTransform:(CATransform3D)transform;

@property (readonly, nonatomic) CATransform3D transform;

@end

NS_ASSUME_NONNULL_END
