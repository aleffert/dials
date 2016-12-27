//
//  NSView+Layout.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/9/14.
//
//

import Cocoa

extension NSView {
    @discardableResult func addConstraintsMatchingSuperviewBounds(_ insets : EdgeInsets = NSEdgeInsetsZero) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints : [NSLayoutConstraint] = []
        
        let attributes = [
            (NSLayoutAttribute.top, insets.top),
            (NSLayoutAttribute.bottom, insets.bottom),
            (NSLayoutAttribute.leading, insets.left),
            (NSLayoutAttribute.trailing, insets.right)
        ]
        
        for (attribute, constant) in attributes {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: .equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: constant)
            
            constraints.append(constraint)
        }
        
        superview?.addConstraints(constraints)
        
        return constraints
    }
    
     @discardableResult func addConstraintsMatchingSuperviewAttributes(_ attributes : [NSLayoutAttribute]) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints : [NSLayoutConstraint] = []
        
        for attribute in attributes {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: .equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: 0)
            
            constraints.append(constraint)
        }
        
        superview?.addConstraints(constraints)
        
        return constraints
    }
}

extension CALayer {
     @discardableResult func addConstraintsMatchingSuperviewBounds(_ insets : EdgeInsets = NSEdgeInsetsZero) -> [CAConstraint] {
        
        var constraints : [CAConstraint] = []
        
        let attributes = [
            (CAConstraintAttribute.minY, insets.top),
            (CAConstraintAttribute.maxY, insets.bottom),
            (CAConstraintAttribute.minX, insets.left),
            (CAConstraintAttribute.maxX, insets.right)
        ]
        
        for (attribute, offset) in attributes {
            let constraint = CAConstraint(attribute: attribute, relativeTo: "superlayer", attribute: attribute, scale: 1, offset: offset)
            
            constraints.append(constraint)
            addConstraint(constraint)
        }
        
        return constraints
    }
}
