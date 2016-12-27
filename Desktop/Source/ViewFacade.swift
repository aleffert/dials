//
//  ViewFacade.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/26/15.
//
//

import Cocoa


enum BorderStyle {
    case normal
    case selected
    case highlighted
    
    fileprivate var color : NSColor {
        switch self {
        case .normal: return NSColor.lightGray.withAlphaComponent(0.4)
        case .selected: return NSColor.blue
        case .highlighted: return NSColor.green
        }
    }
    
    fileprivate var width : CGFloat {
        switch self {
        case .normal: return 1
        case .selected, .highlighted: return 2
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
        
        self.borderStyle = .normal
        
        let layoutManager = CAConstraintLayoutManager() 
        self.layoutManager = layoutManager
        
        addSublayer(contentLayer)
        addSublayer(borderLayer)
        
        borderLayer.addConstraintsMatchingSuperviewBounds(EdgeInsets(top: -1, left: -1, bottom: 1, right: 1))
        
        contentLayer.addConstraintsMatchingSuperviewBounds()
    }
    
    var borderStyle : BorderStyle = .normal {
        didSet {
            borderLayer.borderWidth = borderStyle.width
            borderLayer.borderColor = borderStyle.color.cgColor
        }
    }
    
    override init(layer : Any) {
        super.init(layer : layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
