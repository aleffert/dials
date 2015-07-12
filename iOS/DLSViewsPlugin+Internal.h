//
//  DLSViewsPlugin+Internal.h
//  Dials
//
//  Created by Akiva Leffert on 7/12/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

@class DLSViewsPlugin;

@interface DLSViewsPlugin (Internal)

/// Call when a cheap view property changes, like bounds.
/// Typically this is called automatically by the system when appropriate.
/// @param view The changed view

- (void)viewChangedSurface:(UIView*)view;
/// Call when an expensive view property changes, like layer contents.
/// Typically this is called automatically by the system when appropriate.
/// @param view The changed view
- (void)viewChangedDisplay:(UIView*)view;

@end