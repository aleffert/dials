//
//  NSGeometry+DLSWrappers.h
//  Dials
//
//  Created by Akiva Leffert on 7/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>


#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NSDictionary* DLSWrapUIEdgeInsets(UIEdgeInsets insets);
UIEdgeInsets DLSUnwrapUIEdgeInsets(NSDictionary* values);

NSDictionary* DLSWrapCGPointPoint(CGPoint point);
CGPoint DLSUnwrapCGPointPoint(NSDictionary* values);

NSDictionary* DLSWrapCGPointRect(CGRect rect);
CGRect DLSUnwrapCGPointRect(NSDictionary* values);

NSDictionary* DLSWrapCGPointSize(CGSize size);
CGSize DLSUnwrapCGPointSize(NSDictionary* values);

NS_ASSUME_NONNULL_END

#else

NS_ASSUME_NONNULL_BEGIN

NSDictionary* DLSWrapNSEdgeInsets(NSEdgeInsets insets);
NSEdgeInsets DLSUnwrapNSEdgeInsets(NSDictionary* values);

NS_ASSUME_NONNULL_END

#endif

