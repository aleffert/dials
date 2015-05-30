//
//  DLSViewAdjustPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 4/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Dials/DLSPlugin.h>

NS_ASSUME_NONNULL_BEGIN

/// Plugin that allows you to view and customize properties of views.
/// Similar to the View Debugging feature of Xcode, but allows you to change values
/// and add ones custom to your own view types.
/// To add properties for your custom view have it implement DLSDescribable.
/// See UIView+DLSDescribable for an example.
@interface DLSViewAdjustPlugin : NSObject <DLSPlugin>

/// Will be nil if Dials isn't started
+ (nullable instancetype)activePlugin;

/// Call when a cheap view property changes, like bounds.
/// Typically this is called automatically by the system when appropriate.
/// @param view The changed view

- (void)viewChangedSurface:(UIView*)view;
/// Call when an expensive view property changes, like layer contents.
/// Typically this is called automatically by the system when appropriate.
/// @param view The changed view
- (void)viewChangedDisplay:(UIView*)view;

@end

NS_ASSUME_NONNULL_END
