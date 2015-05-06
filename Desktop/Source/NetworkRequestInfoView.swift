//
//  NetworkRequestInfoView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/6/15.
//
//

import Cocoa

class NetworkRequestInfoView: NSView {
    
    @IBOutlet var contentView : NSView!
    @IBOutlet var requestStatusView : NetworkRequestStatusView!
    @IBOutlet var responseStatusView : NetworkRequestStatusView!

    override init(frame frameRect: NSRect) {
        super.init(frame : frameRect)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        NSBundle.mainBundle().loadNibNamed("NetworkRequestInfoView", owner: self, topLevelObjects: nil)
        addSubview(self.contentView)
        contentView.addConstraintsMatchingSuperviewBounds()
    }
    
    
    var requestInfo : NetworkRequestInfo? {
        didSet {
            requestStatusView.requestInfo = requestInfo
            responseStatusView.requestInfo = requestInfo
        }
    }
}
