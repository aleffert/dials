//
//  NetworkRequestStatusView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/6/15.
//
//

import Cocoa

class NetworkRequestStatusView: NSView {
    let content = NSTextView(frame: CGRectZero)
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        addSubview(content)
        content.addConstraintsMatchingSuperviewBounds()
    }
    
    var requestInfo : NetworkRequestInfo? {
        didSet {
            let headers = requestInfo.map { "\($0.request.allHTTPHeaderFields)" } ?? ""
            content.string = headers
        }
    }
}
