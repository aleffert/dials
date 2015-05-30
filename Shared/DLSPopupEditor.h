//
//  DLSPopupEditor.h
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DLSEditor.h"

NS_ASSUME_NONNULL_BEGIN

@interface DLSPopupOption : NSObject <NSCoding>

- (id)initWithLabel:(NSString*)label value:(id)value;

@property (copy, nonatomic) NSString* label;
@property (strong, nonatomic) id <NSCoding> value;

@end

@interface DLSPopupEditor : NSObject <DLSEditor>

// [DLSPopupOption]
- (id)initWithPopupOptions:(NSArray*)options;

@property (readonly, copy, nonatomic) NSArray* options;

@end


NS_ASSUME_NONNULL_END
