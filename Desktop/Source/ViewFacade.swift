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
    
    private var color : NSColor {
        switch self {
        case Normal: return NSColor.lightGrayColor().colorWithAlphaComponent(0.4)
        case Selected: return NSColor.blueColor()
        case Highlighted: return NSColor.greenColor()
        }
    }
    
    private var width : CGFloat {
        switch self {
        case Normal: return 1
        case Selected, Highlighted: return 2
        }
    }
}

class ViewFacade : CATransformLayer {
    // This is for selection so it doesn't interfere with the content border properties
    let borderLayer = CALayer()
    // This matches the view's properties
    let contentLayer = CALayer()
    // This is the z depth
    var hierarchyDepth = 0
    var selectable : Bool = true
    
    var record : DLSViewHierarchyRecord!
    
    init(record : DLSViewHierarchyRecord) {
        self.record = record
        
        super.init()
        
        self.borderStyle = .Normal
        
        let layoutManager = CAConstraintLayoutManager() 
        self.layoutManager = layoutManager
        
        addSublayer(contentLayer)
        addSublayer(borderLayer)
        
        borderLayer.addConstraintsMatchingSuperviewBounds(NSEdgeInsets(top: -1, left: -1, bottom: 1, right: 1))
        
        contentLayer.addConstraintsMatchingSuperviewBounds()
    }
    
    var borderStyle : BorderStyle = .Normal {
        didSet {
            borderLayer.borderWidth = borderStyle.width
            borderLayer.borderColor = borderStyle.color.CGColor
        }
    }
    
    override init(layer : AnyObject) {
        super.init(layer : layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}