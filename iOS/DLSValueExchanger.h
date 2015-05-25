//
//  DLSValueExchanger.h
//  Dials-Shared
//
//  Created by Akiva Leffert on 1/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

typedef id __nonnull (^DLSMapper)(id);
typedef id __nonnull (^DLSValueFrom)(void);
typedef void (^DLSValueTo)(id);

@class DLSPropertyWrapper;


// This is essentially a lens. Eventually we'll add a typed swift version
@interface DLSValueMapper : NSObject

- (id)initWithFrom:(DLSMapper)from to:(DLSMapper)to;

@property (readonly, copy, nonatomic) DLSMapper to;
@property (readonly, copy, nonatomic) DLSMapper from;

@end

@interface DLSValueExchanger : NSObject

- (DLSPropertyWrapper*)wrapperFromObject:(id)object;
- (DLSValueExchanger*)transform:(DLSValueMapper*)mapper;

@end


@interface DLSKeyPathExchanger : DLSValueExchanger

- (instancetype)initWithKeyPath:(NSString*)keyPath;

@end

// Wraps up a CGColor so that everything who sees it gets a UIColor
@interface DLSCGColorMapper : DLSValueMapper

@end

@interface DLSViewControllerClassExchanger : DLSValueExchanger

@end

@interface DLSEdgeInsetsMapper : DLSValueMapper

@end

@interface DLSPointMapper : DLSValueMapper

@end

@interface DLSRectMapper : DLSValueMapper

@end

@interface DLSSizeMapper : DLSValueMapper

@end

NS_ASSUME_NONNULL_END
