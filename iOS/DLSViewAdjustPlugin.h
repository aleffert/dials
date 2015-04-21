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

@interface DLSViewAdjustPlugin : NSObject <DLSPlugin>

+(instancetype)sharedPlugin;

@end

@interface DLSViewAdjustPlugin (DLSPrivate)

- (void)viewChanged:(UIView*)view;

@end