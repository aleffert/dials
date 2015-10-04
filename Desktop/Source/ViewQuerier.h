//
//  ViewQuerier.h
//  Dials
//
//  Created by Akiva Leffert on 9/26/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DLSAuxiliaryConstraintInformation;

@protocol ViewQuerier <NSObject>

- (NSString*)nameForViewWithID:(nullable NSString*)mainID relativeToView:(NSString*)relativeID withClass:(nullable NSString*)sourceClass constraintInfo:(nullable id <DLSAuxiliaryConstraintInformation>)info;

- (void)selectViewWithID:(NSString*)viewID;
- (void)highlightViewWithID:(NSString*)viewID;
- (void)clearHighlightForViewWithID:(NSString*)viewID;

@end

@protocol ViewQuerierOwner <NSObject>

@property (weak, nonatomic, nullable) id <ViewQuerier> viewQuerier;

@end


NS_ASSUME_NONNULL_END
