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

@interface DLSValueExchanger : NSObject

- (DLSPropertyWrapper*)wrapperFromObject:(id)object;
- (DLSValueExchanger*)transform:(DLSValueMapper*)mapper;

@end


@interface DLSKeyPathExchanger : DLSValueExchanger

- (instancetype)initWithKeyPath:(NSString*)keyPath;

@end

/// Extracts the class name of the owning view controller from the object
/// if it's a view.
@interface DLSViewControllerClassExchanger : DLSValueExchanger
@end

/// Triggers the layout process of a view
@interface DLSTriggerLayoutExchanger : DLSValueExchanger
@end

NS_ASSUME_NONNULL_END
