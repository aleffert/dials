//
//  DLSValueMapper.h
//  Dials
//
//  Created by Akiva Leffert on 5/25/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef id __nonnull (^DLSMapper)(id);

/// Some types are difficult to transfer between device and desktop because they don't implement
/// NSCoding, or they have no analogous object on the other side.
/// You can compose a mapper onto a DLSPropertyDescription to transform an object to something usable
/// on both sides.
@interface DLSValueMapper : NSObject

- (id)initWithFrom:(DLSMapper)from to:(DLSMapper)to;

@property (readonly, copy, nonatomic) DLSMapper to;
@property (readonly, copy, nonatomic) DLSMapper from;

@end

// Coerces an array to its count as a string
@interface DLSArrayCountMapper : DLSValueMapper

@end

// Coerces a number to a printable string and back
@interface DLSNumericDescriptionMapper : DLSValueMapper
@end


/// In: CGColor.
/// Out: UIColor (which Cocoa bridges to NSColor automatically).
@interface DLSCGColorMapper : DLSValueMapper
@end

/// In: UIImage.
/// Out: NSData.
@interface DLSImageDataMapper : DLSValueMapper
@end

@interface DLSEdgeInsetsMapper : DLSValueMapper
@end

@interface DLSPointMapper : DLSValueMapper
@end

@interface DLSRectMapper : DLSValueMapper
@end

@interface DLSSizeMapper : DLSValueMapper
@end


/// A <DLSEditor> can implement this protocol to pick up a default mapper
/// For example, the one for CGColor maps it to a UIColor, which is automatically bridged to
/// an NSColor on the desktop side by Cocoa when decoded.

@protocol DLSDefaultEditorMapping <NSObject>
- (DLSValueMapper*)defaultMapper;
@end

NS_ASSUME_NONNULL_END
