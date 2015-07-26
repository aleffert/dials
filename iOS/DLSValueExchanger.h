//
//  DLSValueExchanger.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DLSValueMapper;

typedef id __nonnull (^DLSValueFrom)(void);
typedef void (^DLSValueTo)(id);

@class DLSPropertyWrapper;

/// Given an object, generates a way of reading/writing part of it
@interface DLSValueExchanger : NSObject

- (id)initWithFrom:(DLSValueFrom(^)(id))from to:(DLSValueTo(^)(id))to NS_DESIGNATED_INITIALIZER;

- (DLSPropertyWrapper*)wrapperFromObject:(id)object;
- (DLSValueExchanger*)transform:(DLSValueMapper*)mapper;

@end

/// Given an object, generates a way of reading/writing a particular keyPath
@interface DLSKeyPathExchanger : DLSValueExchanger

- (instancetype)initWithKeyPath:(NSString*)keyPath;

@end

/// Extracts the class name of the owning view controller from the object
/// if it's a view.
@interface DLSViewControllerClassExchanger : DLSValueExchanger
- (id)init;
@end

/// Triggers the layout process of a view
@interface DLSTriggerLayoutExchanger : DLSValueExchanger
- (id)init;
@end

NS_ASSUME_NONNULL_END
