//
//  DLSDials.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSDials : NSObject

+ (DLSDials*)shared;

/// Starts Dials, telling all plugins to load and advertising it over Bonjour.
/// Same as [dials startWithPlugins:[dials defaultPlugins]].
- (void)start;

/// Starts Dials, telling all plugins to load and advertising it over Bonjour.
/// @param plugins An array of plugins that implement <DLSPlugin>.
- (void)startWithPlugins:(NSArray*)plugins;

/// @return A list of plugins implementing <DLSPlugin>.
/// If you want to add your own plugins, you can can call -startWithPlugins:
/// with your own plugins appended to this array.
- (NSArray*)defaultPlugins;

@end

NS_ASSUME_NONNULL_END