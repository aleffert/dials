//
//  NSGeometry+DLSWrappers.m
//  Dials
//
//  Created by Akiva Leffert on 7/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "NSGeometry+DLSWrappers.h"


#if TARGET_OS_IPHONE

NSDictionary* DLSWrapUIEdgeInsets(UIEdgeInsets insets) {
    return @{@"top" : @(insets.top), @"left" : @(insets.left), @"bottom" : @(insets.bottom), @"right" : @(insets.right)};
}

UIEdgeInsets DLSUnwrapUIEdgeInsets(NSDictionary* values) {
    return UIEdgeInsetsMake([values[@"top"] floatValue], [values[@"left"] floatValue], [values[@"bottom"] floatValue], [values[@"right"] floatValue]);
}

NSDictionary* DLSWrapCGPointPoint(CGPoint point) {
    return @{@"x" : @(point.x), @"y" : @(point.y)};
}

CGPoint DLSUnwrapCGPointPoint(NSDictionary* values) {
    return CGPointMake([values[@"x"] floatValue], [values[@"y"] floatValue]);
}

NSDictionary* DLSWrapCGPointSize(CGSize size) {
    return @{@"width" : @(size.width), @"height" : @(size.height)};
}

CGSize DLSUnwrapCGPointSize(NSDictionary* values) {
    return CGSizeMake([values[@"width"] floatValue], [values[@"height"] floatValue]);
}

NSDictionary* DLSWrapCGPointRect(CGRect rect) {
    return @{@"x" : @(rect.origin.x), @"y" : @(rect.origin.y), @"width" : @(rect.size.width), @"height" : @(rect.size.height)};
}

CGRect DLSUnwrapCGPointRect(NSDictionary* values) {
    return CGRectMake([values[@"x"] floatValue], [values[@"y"] floatValue], [values[@"width"] floatValue], [values[@"height"] floatValue]);
}

#else

NSDictionary* DLSWrapNSEdgeInsets(NSEdgeInsets insets) {
    return @{@"top" : @(insets.top), @"left" : @(insets.left), @"bottom" : @(insets.bottom), @"right" : @(insets.right)};
}

NSEdgeInsets DLSUnwrapNSEdgeInsets(NSDictionary* values) {
    return NSEdgeInsetsMake([values[@"top"] floatValue], [values[@"left"] floatValue], [values[@"bottom"] floatValue], [values[@"right"] floatValue]);
}

#endif