//
//  LiveDialsPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

class LiveDialsPlugin: NSObject, Plugin {
    
    var name : String = "com.akivaleffert.live-dials"

    var displayName : String = "Control Panel"
    
    func receiveMessage(data: NSData, channel: DLSChannel) {
        
    }
    
    func connectedWithContext(context: PluginContext) {
        
    }
    
    func disconnected() {
        
    }
}
