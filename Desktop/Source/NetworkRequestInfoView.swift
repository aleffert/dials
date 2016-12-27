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
    @IBOutlet var requestTabController : RequestContentTabController!
    @IBOutlet var responseTabController : RequestContentTabController!

    override init(frame frameRect: NSRect) {
        super.init(frame : frameRect)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        Bundle.main.loadNibNamed("NetworkRequestInfoView", owner: self, topLevelObjects: nil)
        addSubview(self.contentView)
        contentView.addConstraintsMatchingSuperviewBounds()
        requestTabController.dataExtractor = RequestContentTabController.requestDataExtractor
        responseTabController.dataExtractor = RequestContentTabController.responseDataExtractor
    }
    
    
    var requestInfo : NetworkRequestInfo? {
        didSet {
            requestTabController.requestInfo = requestInfo
            responseTabController.requestInfo = requestInfo
        }
    }
}
