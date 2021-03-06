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

@protocol DLSConstraintInformer;
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
/// add properties for classes that are project specific or not part of the
/// Dials distribution. For example, if your project has a custom <code>extension</code> for UIView
/// you could use this to add an editor for it.
///
/// @param klass The class to add an editor for. Will also add it for any subclasses of that class.
/// @param generator A function called by the system add that adds view description groups.
/// @return A way to remove the added description functions.
- (id <DLSRemovable>)addExtraViewDescriptionForClass:(Class)klass generator:(void(^)(id <DLSDescriptionContext> context))generator;

/// Adds additional information to NSLayoutConstraints captured by this plugin. Can be used
/// in conjunction with an autolayout library to support extra editing features.
///
/// @param informer A class implementing a protocol that returns extra information given an
/// NSLayoutConstraint. Will connect to a corresponding desktop plugin that implements
/// <code>ConstraintPlugin</code>.
/// @return A way to remove the added description functions.
- (id <DLSRemovable>)addAuxiliaryConstraintInformer:(id <DLSConstraintInformer>)informer;

@end

NS_ASSUME_NONNULL_END
