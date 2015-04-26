//
//  NSView+Layout.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/9/14.
//
//

import Cocoa

extension NSView {
    func addConstraintsMatchingSuperviewBounds(insets : NSEdgeInsets = NSEdgeInsetsZero) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints : [NSLayoutConstraint] = []
        
        let attributes = [
            (NSLayoutAttribute.Top, insets.top),
            (NSLayoutAttribute.Bottom, insets.bottom),
            (NSLayoutAttribute.Leading, insets.left),
            (NSLayoutAttribute.Trailing, insets.right)
        ]
        
        for (attribute, constant) in attributes {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: .Equal,
                toItem: superview,
                attribute: attribute,
                multiplier: 1,
                constant: constant)
            
            constraints.append(constraint)
        }
        
        superview?.addConstraints(constraints)
        
        return constraints
    }
    
    func addConstraintsMatchingSuperviewAttributes(attributes : [NSLayoutAttribute]) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints : [NSLayoutConstraint] = []
        
        for attribute in attributes {
            let constraint = NSLayoutConstraint(
                item: self,
                attribute: attribute,
                relatedBy: .Equal,
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
    func addConstraintsMatchingSuperviewBounds(insets : NSEdgeInsets = NSEdgeInsetsZero) -> [CAConstraint] {
        
        var constraints : [CAConstraint] = []
        
        let attributes = [
            (CAConstraintAttribute.MinY, insets.top),
            (CAConstraintAttribute.MaxY, insets.bottom),
            (CAConstraintAttribute.MinX, insets.left),
            (CAConstraintAttribute.MaxX, insets.right)
        ]
        
        for (attribute, offset) in attributes {
            let constraint = CAConstraint(attribute: attribute, relativeTo: "superlayer", attribute: attribute, scale: 1, offset: offset)
            
            constraints.append(constraint)
            addConstraint(constraint)
        }
        
        return constraints
    }
}