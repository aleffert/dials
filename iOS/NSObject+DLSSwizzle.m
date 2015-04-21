//
//  DLSSwizzle.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 4/20/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import "NSObject+DLSSwizzle.h"

#import <objc/message.h>
#import <objc/runtime.h>

// Copied from JRSwizzle (https://github.com/rentzsch/jrswizzle), but renamed to avoid conflicts and simplified for our use case

#define SetNSErrorFor(FUNC, ERROR_VAR, FORMAT,...)	\
if (ERROR_VAR) {	\
    NSString *errStr = [NSString stringWithFormat:@"%s: " FORMAT,FUNC,##__VA_ARGS__]; \
    *ERROR_VAR = [NSError errorWithDomain:@"NSCocoaErrorDomain" \
                                     code:-1	\
                                 userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]]; \
}
#define SetNSError(ERROR_VAR, FORMAT,...) SetNSErrorFor(__func__, ERROR_VAR, FORMAT, ##__VA_ARGS__)

@implementation NSObject (DLSSwizzle)

+ (BOOL)dls_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel error:(NSError**)error {
    Method origMethod = class_getInstanceMethod(self, origSel);
    if (!origMethod) {
        SetNSError(error, @"original method %@ not found for class %@", NSStringFromSelector(origSel), [self class]);
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!altMethod) {
        SetNSError(error, @"alternate method %@ not found for class %@", NSStringFromSelector(altSel), [self class]);
        return NO;
    }
    
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel), class_getInstanceMethod(self, altSel));
    return YES;

}

+ (BOOL)dls_swizzleClassMethod:(SEL)origSel withClassMethod:(SEL)altSel error:(NSError**)error {
    return [object_getClass((id)self) dls_swizzleMethod:origSel withMethod:altSel error:error];
}

@end
