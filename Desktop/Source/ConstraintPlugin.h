//
//  ConstraintPlugin.h
//  Dials
//
//  Created by Akiva Leffert on 10/4/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DLSAuxiliaryConstraintInformation;

/// A plugin that interacts with the constraint system to add additional features
/// such as saving back to disk.
/// In order to be loaded properly, any plugin that implements <code>ConstraintPlugin</code> *must also* implement <code>Plugin</code>
@protocol ConstraintPlugin <NSObject>

/// Unique identifier for the plugin. Should match the corresponding iOS plugin.
@property (readonly, nonatomic, copy) NSString* identifier;

/// Writes a constraint change back to disk. The constraint information will be the same data sent by the client side plugin with this plugin's <code>identifier</code>.
///
/// @param constraint The constraint information to save.
/// @param constant The new value for the constraint's <code>constant</code> field
/// @return <code>YES</code> on success. <code>NO</code> on failure.
- (BOOL)saveConstraint:(id <DLSAuxiliaryConstraintInformation>)constraint constant:(CGFloat)constant error:(NSError**)error;


/// Returns a user facing name for the constraint based on the underlying code.
///
/// @param constraint The constraint information supplied by the corresponding iOS plugin.
/// and should be safe to cast to your concrete instance of <code>DLSAuxiliaryConstraintInformation</code>.
/// @param constant The new value for the constraint's <code>constant</code> field
/// @return The name to display. <code>nil</code> means use the default.
- (nullable NSString*)displayNameOfConstraint:(id <DLSAuxiliaryConstraintInformation>)info;

@end


NS_ASSUME_NONNULL_END
