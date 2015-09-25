//
//  DLSEditorController.m
//  Dials
//
//  Created by Akiva Leffert on 9/24/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DLSEditor;

NS_ASSUME_NONNULL_BEGIN


@protocol EditorConfiguration <NSObject>

@property (strong, nonatomic, readonly) id <DLSEditor> editor;
@property (copy, nonatomic, readonly) NSString* name;
@property (copy, nonatomic, readonly) NSString* label;
@property (strong, nonatomic, readonly, nullable) id <NSCoding> value;

@end

@protocol EditorController;

@protocol EditorControllerDelegate <NSObject>

- (void)editorController:(id<EditorController>)controller changedConfiguration:(id<EditorConfiguration>)info toValue:(nullable id <NSCoding>)value;

@end

// Implement this to provide an desktop editor for your own custom DLSEditor type
@protocol EditorController <NSObject>

@property (weak, nonatomic) id<EditorControllerDelegate> delegate;
@property (strong, nonatomic, nullable) id <EditorConfiguration> configuration;
@property (assign, nonatomic, readonly) BOOL readOnly;
@property (strong, nonatomic, readonly) NSView* view;

@end


@protocol EditorControllerGenerating <NSObject>

- (id <EditorController>)generateController;

@end

NS_ASSUME_NONNULL_END
