//
//  UIView+DLSViewsPlugin.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 4/18/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+DLSViewsPlugin.h"
#import "DLSViewsPlugin.h"
#import "DLSViewsPlugin+Internal.h"

#import "NSObject+DLSSwizzle.h"

static NSString* DLSViewIDKey = @"DLSViewIDKey";

// All this locking is because some layers may render on background threads
// e.g. for web views
static void DLSWithViewLock(void(^action)(void)) {
    static dispatch_once_t onceToken;
    static NSLock* lock = nil;
    dispatch_once(&onceToken, ^{
        lock = [[NSLock alloc] init];
    });
    [lock lock];
    action();
    [lock unlock];
}

@implementation CALayer (DLSViews)

- (UIView*)dls_view {
    UIView* view = (UIView*)([self.delegate isKindOfClass:[UIView class]] ? self.delegate : nil);
    return view;
}

- (void)dls_display {
    [self dls_display];
    [[DLSViewsPlugin activePlugin] viewChangedDisplay:self.dls_view];
}

- (id <CAAction>)dls_actionForKey:(NSString *)key {
    id <CAAction> result = [self dls_actionForKey:key];
    
    if([key isEqualToString:@"contents"]) {
        [[DLSViewsPlugin activePlugin] viewChangedDisplay:self.dls_view];
    }
    else if(![key isEqualToString:@"delegate"] && ![key isEqualToString:@"sublayers"]) {
        [[DLSViewsPlugin activePlugin] viewChangedSurface:self.dls_view];
    };
    return result;
}

@end

@implementation UIView (DLSViews)

+ (void)dls_setListeningForChanges:(BOOL)listening {
    static BOOL sIsListening = NO;
    if(sIsListening != listening) {
        sIsListening = listening;
        
        // cheap property changes
        DLSSwizzle(self, willMoveToSuperview:);
        DLSSwizzle(self, didMoveToSuperview);
        DLSSwizzle(self, exchangeSubviewAtIndex:withSubviewAtIndex:);
        DLSSwizzle(self, insertSubview:aboveSubview:);
        DLSSwizzle(self, insertSubview:atIndex:);
        DLSSwizzle(self, insertSubview:belowSubview:);
        DLSSwizzle(self, bringSubviewToFront:);
        DLSSwizzle(self, sendSubviewToBack:);
        DLSSwizzle(self, willMoveToWindow:);
        DLSSwizzle(self, didMoveToWindow);

        // expensive property changes
        DLSSwizzle(CALayer, display);
        DLSSwizzle(CALayer, actionForKey:);
    }
}

// Observer methods

- (void)dls_willMoveToSuperview:(UIView*)superview {
    [self dls_willMoveToSuperview:superview];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self.superview];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:superview];
}

- (void)dls_didMoveToSuperview {
    [self dls_didMoveToSuperview];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self.superview];
}

- (void)dls_exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2 {
    [self dls_exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self];
}

- (void)dls_insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
    [self dls_insertSubview:view aboveSubview:siblingSubview];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self];
}

- (void)dls_insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [self dls_insertSubview:view atIndex:index];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self];
}

- (void)dls_insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview {
    [self dls_insertSubview:view belowSubview:siblingSubview];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self];
}

- (void)dls_bringSubviewToFront:(UIView*)view {
    [self dls_bringSubviewToFront:view];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self];
}

- (void)dls_sendSubviewToBack:(UIView *)view {
    [self dls_sendSubviewToBack:view];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self];
}

- (void)dls_willMoveToWindow:(UIWindow*)window {
    [self dls_willMoveToWindow:window];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self.superview];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self];
}

- (void)dls_didMoveToWindow {
    [self dls_didMoveToWindow];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self.superview];
    [[DLSViewsPlugin activePlugin] viewChangedSurface:self];
}

// Unique ID per view

- (NSString*)dls_assignedViewID {
    return objc_getAssociatedObject(self, &DLSViewIDKey);
}

- (NSString*)dls_viewID {
    __block NSString* viewID = self.dls_assignedViewID;
    if(viewID == nil) {
        DLSWithViewLock(^{
            viewID = self.dls_assignedViewID;
            if(viewID == nil) {
                viewID = [NSUUID UUID].UUIDString;
                objc_setAssociatedObject(self, &DLSViewIDKey, viewID, OBJC_ASSOCIATION_RETAIN);
            }
        });
    }
    
    return viewID;
}


@end
