//
//  GroupContainerView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/9/15.
//
//

import AppKit

class GroupContainerView: NSView {
    @IBOutlet private var titleView : NSTextField!
    @IBOutlet private var contentContainerView : NSView!
    @IBOutlet private var bodyView : NSView!
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame : frameRect)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder : coder)
        setup()
    }
    
    func setup() {
        NSBundle.mainBundle().loadNibNamed("GroupContainerView", owner: self, topLevelObjects: nil)
        addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.addConstraintsMatchingSuperviewBounds()
    }
    
    var contentView : NSView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = contentView { self.contentContainerView.addSubview(view) }
            contentView?.addConstraintsMatchingSuperviewBounds()
        }
    }
    
    var title : String {
        get {
            return titleView.stringValue
        }
        set {
            titleView.stringValue = newValue ?? ""
        }
    }
}
