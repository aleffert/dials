//
//  ViewFacade.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/26/15.
//
//

import Cocoa


enum BorderStyle {
    case Normal
    case Selected
    case Highlighted
    
    var color : NSColor {
        switch(self) {
        case Normal: return NSColor.lightGrayColor().colorWithAlphaComponent(0.4)
        case Selected: return NSColor.blueColor()
        case Highlighted: return NSColor.greenColor()
        }
    }
}

class ViewFacade : CATransformLayer {
    let borderLayer = CALayer()
    let contentLayer = CALayer()
    var hierarchyDepth = 0
    
    var record : DLSViewHierarchyRecord!
    
    init(record : DLSViewHierarchyRecord) {
        self.record = record
        
        super.init()
        
        borderLayer.borderWidth = 1
        borderLayer.borderColor = NSColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        
        let layoutManager = CAConstraintLayoutManager.layoutManager() as! CAConstraintLayoutManager
        self.layoutManager = layoutManager
        
        addSublayer(borderLayer)
        addSublayer(contentLayer)
        
        borderLayer.addConstraintsMatchingSuperviewBounds(insets: NSEdgeInsets(top: -1, left: -1, bottom: 1, right: 1))
        
        contentLayer.addConstraintsMatchingSuperviewBounds()
    }
    
    override init(layer : AnyObject!) {
        super.init(layer : layer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}