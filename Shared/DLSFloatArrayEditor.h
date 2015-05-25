//
//  DLSFloatArrayEditor.h
//  Dials
//
//  Created by Akiva Leffert on 5/22/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#import "DLSEditor.h"

NS_ASSUME_NONNULL_BEGIN

@interface DLSFloatArrayEditor : NSObject <DLSEditor>

- (id)initWithLabels:(NSArray*)labels constructor:(nullable NSString*)constructor;

@property (readonly, copy, nonatomic) NSArray* labels;
@property (readonly, copy, nonatomic, nullable) NSString* constructor;

@end

@interface DLSEdgeInsetsEditor : DLSFloatArrayEditor
@end

@interface DLSPointEditor : DLSFloatArrayEditor
@end

@interface DLSSizeEditor : DLSFloatArrayEditor
@end

@interface DLSRectEditor : DLSFloatArrayEditor
@end

#if TARGET_OS_IPHONE

NSDictionary* DLSEncodeUIEdgeInsets(UIEdgeInsets insets);
UIEdgeInsets DLSDecodeUIEdgeInsets(NSDictionary* values);

NSDictionary* DLSEncodeCGPoint(CGPoint point);
CGPoint DLSDecodeCGPoint(NSDictionary* values);

NSDictionary* DLSEncodeCGRect(CGRect rect);
CGRect DLSDecodeCGRect(NSDictionary* values);

NSDictionary* DLSEncodeCGSize(CGSize size);
CGSize DLSDecodeCGSize(NSDictionary* values);

#endif

NS_ASSUME_NONNULL_END
