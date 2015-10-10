//
//  UIView+DLSViewsPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 4/18/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DLSViews)

+ (void)dls_setListeningForChanges:(BOOL)listening;

/// Returns the view's unique id, assigning it if necessary
@property (readonly, nonatomic) NSString* dls_assignedViewID;
/// Returns the view's unique id, assigning it if necessary
@property (readonly, nonatomic) NSString* dls_viewID;

@end

NS_ASSUME_NONNULL_END
