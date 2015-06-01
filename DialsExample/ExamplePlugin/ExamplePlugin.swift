//
//  ExamplePlugin.swift
//  DialsExample
//
//  Created by Akiva Leffert on 5/31/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Foundation

class ExampleViewController : NSViewController {
    override func loadView() {
        self.view = NSView(frame: NSZeroRect)
    }
}

class ExamplePlugin : NSObject, Plugin {
    
    var context : PluginContext?
    var controller : NSViewController?
    
    let identifier = ExamplePluginIdentifier
    let label = "Example"
    let shouldSortChildren = false
    
    func receiveMessage(message: NSData) {
        println("got a message")
    }
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
        self.controller = ExampleViewController(nibName: nil, bundle: nil)
        self.context?.addViewController(self.controller!, plugin: self)
    }
    
    func connectionClosed() {
        self.context?.addViewController(self.controller!, plugin: self)
        self.context = nil
        self.controller = nil
    }
}