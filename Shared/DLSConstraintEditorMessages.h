//
//  DLSConstraintEditorMessages.h
//  Dials
//
//  Created by Akiva Leffert on 9/30/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLSUpdateConstraintConstantMessage : NSObject <NSCoding>

- (id)initWithConstraintID:(NSString*)constraintID constant:(CGFloat)constant;

@property (copy, nonatomic, readonly) NSString* constraintID;
@property (assign, nonatomic, readonly) CGFloat constant;

@end

NS_ASSUME_NONNULL_END
