//
//  DLSAuxiliaryConstraintInformation.h
//  Dials
//
//  Created by Akiva Leffert on 9/27/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DLSSourceLocation;

@protocol DLSAuxiliaryConstraintInformation <NSObject, NSCoding>

@property (readonly, copy, nonatomic) NSString* pluginIdentifier;
@property (readonly, assign, nonatomic) BOOL supportsSaving;
@property (readonly, strong, nonatomic, nullable) id <DLSSourceLocation> location;

@end

NS_ASSUME_NONNULL_END
