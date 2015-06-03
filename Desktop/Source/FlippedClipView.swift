//
//  FlippedClipView.swift
//  Dials
//
//  Created by Akiva Leffert on 6/2/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Cocoa

class FlippedClipView : NSClipView {
    override var flipped : Bool {
        return true;
    }
}
