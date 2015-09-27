//
//  DLSAuxiliaryConstraintInformation.h
//  Dials
//
//  Created by Akiva Leffert on 9/27/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSAuxiliaryConstraintInformation : NSObject

- (id)initWithPluginIdentifier:(NSString*)identifier userData:(id <NSCoding>)userData;

@property (readonly, copy, nonatomic) NSString* pluginIdentifier;
@property (readonly, strong, nonatomic) id<NSCoding> userData;

@end

NS_ASSUME_NONNULL_END
