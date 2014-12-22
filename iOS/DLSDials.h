//
//  DLSDials.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DLSDials : NSObject

+ (DLSDials*)shared;

/// Starts Dials, advertising it over Bonjour.
/// Same as [dials startWithPlugins:[dials defaultPlugins]]
- (void)start;

/// Starts Dials, advertising it over Bonjour, allowing the caller to specify
/// the available plugins.
/// @param plugins An array of plugins that implement <DLSPlugin>
- (void)startWithPlugins:(NSArray*)plugins;

/// @return A list of plugins implementing <DLSPlugin>
- (NSArray*)defaultPlugins;

@end
