//
//  DLSSwizzle.h
//  Dials-iOS
//
//  Created by Akiva Leffert on 4/20/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DLSSwizzle)

+ (BOOL)dls_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel error:(NSError**)error;
+ (BOOL)dls_swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel error:(NSError**)error;

@end
