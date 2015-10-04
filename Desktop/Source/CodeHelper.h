//
//  CodeHelper.h
//  Dials
//
//  Created by Akiva Leffert on 10/4/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CodeHelper;
@protocol DLSEditor;

typedef NS_ENUM(NSUInteger, Language) {
    LanguageObjC,
    LanguageSwift
};

/// Implement this protocol on your plugin if it needs to access to a CodeHelper.
/// CodeHelper provides useful utilties for modifying code on disk.
@protocol CodeHelperOwner <NSObject>

/// The <code>codeHelper</code> will be automatically assigned by Dials when the plugin is loaded.
@property (nonatomic, strong, nullable) id <CodeHelper> codeHelper;

@end

@protocol CodeHelper <NSObject>

/// Replaces the assignment of <code>symbol</code> to a new value in a given file.
/// For example, if your code in file <code>f</code> contains "let x = 3" and the
/// value passed in is "4",
/// it will modify the contents of <code>f</code> to contain "let x = 4".
///
/// @param symbol The symbol to update. This is typically the name of a variable.
/// @param value The value to replace it with.
/// @param editor The editor that changed the value. Used to ensure the value is of the appropriate type.
/// @param url A URL for the file to modify.
/// @param error Will be set if the operation fails.
/// @return Whether the operation succeeded.
- (BOOL)updateSymbol:(NSString*)symbol toValue:(nullable id<NSCoding>)value withEditor:(id <DLSEditor>)editor atURL:(NSURL*)url error:(NSError**)error;

/// Replaces the assignment of <code>symbol</code> to a new string in a given file.
/// For example, if your code in file <code>f</code> contains "let x = 3" and the
/// string passed in is "4",
/// it will modify the contents of <code>f</code> to contain "let x = 4".
///
/// @param symbol The symbol to update. This is typically the name of a variable.
/// @param code The code string to replace it with.
/// @param url A URL for the file to modify.
/// @param error Will be set if the operation fails.
/// @return Whether the operation succeeded.
- (BOOL)updateSymbol:(NSString*)symbol toCode:(NSString*)code inLanguage:(Language)lang atURL:(NSURL*)url error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
