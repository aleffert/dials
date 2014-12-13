//
//  NSView+Layout.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/9/14.
//
//

import Cocoa

extension NSView {
    func addConstraintsMatchingSuperviewBounds() -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints : [NSLayoutConstraint] = []
        
        let attributes = [
            NSLayoutAttribute.Top,
            NSLayoutAttribute.Bottom,
            NSLayoutAttribute.Leading,
            NSLayoutAttribute.Trailing
        ]
        
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
