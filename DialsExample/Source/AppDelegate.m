//
//  AppDelegate.m
//  DialsExample
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "AppDelegate.h"

#import <Dials/Dials.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // You should enable dials on debug builds so you don't accidentally ship
    // with it enabled.
#if DEBUG
    
    [[DLSDials shared] start];
    
#endif
    
    return YES;
}

@end
