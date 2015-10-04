//
//  DLSEditorController.m
//  Dials
//
//  Created by Akiva Leffert on 9/24/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// How to add an editor:
// 1. Declare an instance of DLSEditor. This will be shared by both your iOS app and your
// desktop plugin.
// 2. In your desktop plugin, implement <code>EditorControllerGenerating</code> and, if appropriate,  <code>CodeGenerating</code>.
// 3. In your iOS app, add a property that should be modified with that editor.

@protocol DLSEditor;

NS_ASSUME_NONNULL_BEGIN

/// Supplies information needed to configure your <code>EditorController</code> for a field.
@protocol EditorConfiguration <NSObject>

/// The editor that should be used to edit this field.
@property (strong, nonatomic, readonly) id <DLSEditor> editor;
/// A unique name belonging to this editor.
@property (copy, nonatomic, readonly) NSString* name;
/// A user facing name for this editor.
@property (copy, nonatomic, readonly) NSString* label;
/// The current value of the field.
@property (strong, nonatomic, readonly, nullable) id <NSCoding> value;

@end

@protocol EditorController;

/// Allows your EditorController to communicate back up to the system.
@protocol EditorControllerDelegate <NSObject>

/// Informs the system that a value changed. This triggers propagation of the new value back to the iOS side.
///
/// @param controller The sending controller.
/// @param value The new value.
- (void)editorController:(id<EditorController>)controller changedToValue:(nullable id <NSCoding>)value;

@end

/// Your custom editor should implement this protocol so it can supply an view.
@protocol EditorController <NSObject>

/// Will be set by Dials when the controller is loaded.
@property (weak, nonatomic) id<EditorControllerDelegate> delegate;

/// Information about the current field being edited. Will be set by Dials when the controller
/// is loaded.
@property (strong, nonatomic, nullable) id <EditorConfiguration> configuration;
/// Return false if your editor does not support saving. For example, a button that trigger
/// an action has no code to write.
@property (assign, nonatomic, readonly) BOOL readOnly;
/// The editing view. Its size will be maintained by autolayout.
@property (strong, nonatomic, readonly) NSView* view;

@end

/// Implements this protocol on your <code>DLSEditor</code> to provide an editor
@protocol EditorControllerGenerating <NSObject>

/// Return a new editor controller that can edit your custom <code>DLSEditor</code> instance.
- (id <EditorController>)generateController;

@end

/// Implement this protocol on your <code>DLSEditor</code> implementation
/// to allow your custom editor to generate code when the save button is pressed.
@protocol CodeGenerating <NSObject>

/// @param The value the code represents. For example, for a slider editor, this would be the current numeric value of the slider.
/// @param language The language to generate code for.
/// @returns The code to be written.
- (NSString*)codeForValue:(nullable id<NSCoding>)value language:(Language)language;

@end

NS_ASSUME_NONNULL_END
