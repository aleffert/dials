//
//  UIView+DLSViewID.m
//  Dials-iOS
//
//  Created by Akiva Leffert on 4/18/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+DLSViewAdjust.h"
#import "DLSViewAdjustPlugin.h"

#import "NSObject+DLSSwizzle.h"

static NSString* DLSViewIDKey = @"DLSViewIDKey";

@implementation CALayer (DLSViewAdjust)

- (UIView*)dls_view {
    UIView* view = [self.delegate isKindOfClass:[UIView class]] ? self.delegate : nil;
    return view;
}

- (void)dls_display {
    [self dls_display];
    [[DLSViewAdjustPlugin sharedPlugin] viewChangedDisplay:self.dls_view];
}

- (id <CAAction>)dls_actionForKey:(NSString *)key {
    id <CAAction> result = [self dls_actionForKey:key];
    
    if(![key isEqualToString:@"delegate"] && ![key isEqualToString:@"sublayers"]) {
        [[DLSViewAdjustPlugin sharedPlugin] viewChangedSurface:self.dls_view];
    };
    return result;
}

@end

@implementation UIView (DLSViewAdjust)

+ (void)dls_setListening:(BOOL)listening {
    static BOOL sIsListening = NO;
    if(sIsListening != listening) {
        sIsListening = listening;
        // cheap property changes
        NSError* error = nil;
        [self dls_swizzleMethod:@selector(didMoveToSuperview) withMethod:@selector(dls_didMoveToSuperview) error:&error];
        NSAssert(error == nil, @"Dials: Error swizzling in view change listeners");
        [self dls_swizzleMethod:@selector(exchangeSubviewAtIndex:withSubviewAtIndex:) withMethod:@selector(dls_exchangeSubviewAtIndex:withSubviewAtIndex:) error:&error];
        NSAssert(error == nil, @"Dials: Error swizzling in view change listeners");
        [self dls_swizzleMethod:@selector(insertSubview:aboveSubview:) withMethod:@selector(dls_insertSubview:aboveSubview:) error:&error];
        NSAssert(error == nil, @"Dials: Error swizzling in view change listeners");
        [self dls_swizzleMethod:@selector(insertSubview:atIndex:) withMethod:@selector(dls_insertSubview:atIndex:) error:&error];
        NSAssert(error == nil, @"Dials: Error swizzling in view change listeners");
        [self dls_swizzleMethod:@selector(insertSubview:belowSubview:) withMethod:@selector(dls_insertSubview:belowSubview:) error:&error];
        NSAssert(error == nil, @"Dials: Error swizzling in view change listeners");
        [self dls_swizzleMethod:@selector(bringSubviewToFront:) withMethod:@selector(dls_bringSubviewToFront:) error:&error];
        NSAssert(error == nil, @"Dials: Error swizzling in view change listeners");
        [self dls_swizzleMethod:@selector(sendSubviewToBack:) withMethod:@selector(dls_sendSubviewToBack:) error:&error];
        NSAssert(error == nil, @"Dials: Error swizzling in view change listeners");
        [self dls_swizzleMethod:@selector(didMoveToWindow) withMethod:@selector(dls_didMoveToWindow) error:&error];
        NSAssert(error == nil, @"Dials: Error swizzling in view change listeners");
        
        // expensive property changes
        [UIView dls_swizzleMethod:@selector(drawRect:) withMethod:@selector(dls_drawRect:) error:&error];
        NSAssert(error == nil, @"Dials: Error swizzling in view change listeners");
        [CALayer dls_swizzleMethod:@selector(display) withMethod:@selector(dls_display) error:&error];
        NSAssert(error == nil, @"Dials: Error swizzling in view change listeners");
        [CALayer dls_swizzleMethod:@selector(actionForKey:) withMethod:@selector(dls_actionForKey:) error:&error];
        NSAssert(error == nil, @"Dials: Error swizzling in view change listeners");
    }
}

// Observer methods

- (void)dls_didMoveToSuperview {
    [self dls_didMoveToSuperview];
    [[DLSViewAdjustPlugin sharedPlugin] viewChangedSurface:self.superview];
}

- (void)dls_exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2 {
    [self dls_exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
    [[DLSViewAdjustPlugin sharedPlugin] viewChangedSurface:self];
}

- (void)dls_insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview {
    [self dls_insertSubview:view aboveSubview:siblingSubview];
    [[DLSViewAdjustPlugin sharedPlugin] viewChangedSurface:self];
}

- (void)dls_insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [self dls_insertSubview:view atIndex:index];
    [[DLSViewAdjustPlugin sharedPlugin] viewChangedSurface:self];
}

- (void)dls_insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview {
    [self dls_insertSubview:view belowSubview:siblingSubview];
    [[DLSViewAdjustPlugin sharedPlugin] viewChangedSurface:self];
}

- (void)dls_bringSubviewToFront:(UIView*)view {
    [self dls_bringSubviewToFront:view];
    [[DLSViewAdjustPlugin sharedPlugin] viewChangedSurface:self];
}

- (void)dls_sendSubviewToBack:(UIView *)view {
    [self dls_sendSubviewToBack:view];
    [[DLSViewAdjustPlugin sharedPlugin] viewChangedSurface:self];
}

- (void)dls_didMoveToWindow {
    [self dls_didMoveToWindow];
    [[DLSViewAdjustPlugin sharedPlugin] viewChangedSurface:self.superview];
    [[DLSViewAdjustPlugin sharedPlugin] viewChangedSurface:self];
}

- (void)dls_drawRect:(CGRect)rect {
    [self dls_drawRect:rect];
    [[DLSViewAdjustPlugin sharedPlugin] viewChangedDisplay:self];
}

// Unique ID per view

- (NSString*)dls_viewID {
    NSString* viewID = objc_getAssociatedObject(self, &DLSViewIDKey);
    if(viewID == nil) {
        viewID = [NSUUID UUID].UUIDString;
        objc_setAssociatedObject(self, &DLSViewIDKey, viewID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return viewID;
}


@end
