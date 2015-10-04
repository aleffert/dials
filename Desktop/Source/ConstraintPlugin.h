//
//  ConstraintPlugin.h
//  Dials
//
//  Created by Akiva Leffert on 10/4/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CodeHelper;

typedef NS_ENUM(NSUInteger, Language) {
    LanguageObjC,
    LanguageSwift
};

@protocol DLSAuxiliaryConstraintInformation;

@protocol ConstraintPlugin <NSObject>

/// Unique identifier for the plugin. Should match the corresponding iOS side plugin.
@property (readonly, nonatomic, copy) NSString* identifier;

/// Writes a constraint . The constraint information will be the same data sent by the client side plugin with this plugin's <code>identifier</code>.
/// @return <code>YES</code> on success. <code>NO</code> on failure.
- (BOOL)saveConstraint:(id <DLSAuxiliaryConstraintInformation>)constraint constant:(CGFloat)constant error:(NSError**)error;
- (nullable NSString*)displayNameOfConstraint:(id <DLSAuxiliaryConstraintInformation>)info;

@end


NS_ASSUME_NONNULL_END
