//
//  DLSViewsPlugin.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 4/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Dials/DLSPlugin.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DLSDescriptionContext;
@protocol DLSRemovable;

/// Plugin that allows you to view and customize properties of views.
/// Similar to the View Debugging feature of Xcode, but allows you to change values
/// and add ones custom to your own view types.
/// To add properties for your custom view have it implement DLSDescribable.
/// See UIView+DLSDescribable for an example.
@interface DLSViewsPlugin : NSObject <DLSPlugin>

/// Will be nil if Dials isn't started
+ (nullable instancetype)activePlugin;


/// Add an extra description group for a given class. Provides an easy way to
/// Add properties for classes that are project specific or not part of the
/// Dials distribution. For example, if your project has a custom ``extension`` for UIView
/// you could use this to add an editor for it.
///
/// @param klass The class to add an editor for. Will also add it for any subclasses of that class.
/// @param generator A function called by the system add that adds view description groups.
/// @return A way to remove the added description functions
- (id <DLSRemovable>)addExtraViewDescriptionForClass:(Class)klass generator:(void(^)(id <DLSDescriptionContext> context))generator;

@end

NS_ASSUME_NONNULL_END
