//
//  AppDelegate.m
//  DialsExample
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "AppDelegate.h"

#import <Dials/DialsFramework.h>

@interface TestPlugin : NSObject <DLSPlugin>

@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[DLSDials shared] start];
    return YES;
}

@end
