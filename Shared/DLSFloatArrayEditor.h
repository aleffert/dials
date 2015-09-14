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

- (id)initWithLabels:(NSArray<NSString*>*)labels constructor:(nullable NSString*)constructor;

@property (readonly, copy, nonatomic) NSArray<NSString*>* labels;
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


NS_ASSUME_NONNULL_END
