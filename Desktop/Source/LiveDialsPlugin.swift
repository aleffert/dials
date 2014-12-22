//
//  LiveDialsPlugin.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/6/14.
//
//

import Cocoa

class ColorView : NSView {
    var backgroundColor : NSColor?
    
    override func drawRect(dirtyRect: NSRect) {
        self.backgroundColor?.setFill()
        NSRectFill(dirtyRect)
    }
    
    override var opaque : Bool {
        get {
            return false
        }
    }
}

func randomColor() -> NSColor {
    let r = CGFloat(arc4random_uniform(256)) / 255.0
    let g = CGFloat(arc4random_uniform(256)) / 255.0
    let b = CGFloat(arc4random_uniform(256)) / 255.0
    return NSColor(deviceRed: r, green: g, blue: b, alpha: 1.0)
}

class ColorViewController : NSViewController {
    override func loadView() {
        let colorView = ColorView(frame: CGRectZero)
        colorView.backgroundColor = randomColor()
        self.view = colorView
    }
}

class LiveDialsPlugin: NSObject, Plugin {
    
    var name : String = "com.akivaleffert.live-dials"

    var displayName : String = "Control Panel"
    
    private var knownChannels : [String:NSViewController] = [:]
    private var context : PluginContext?
    
    func receiveMessage(data: NSData, channel: DLSChannel) {
        if knownChannels[channel.name] == nil {
            let controller = ColorViewController(nibName: nil, bundle: nil)!
            controller.title = channel.name
            context?.addViewController(controller, plugin:self)
            knownChannels[channel.name] = controller
        }
    }
    
    func connectedWithContext(context: PluginContext) {
        self.context = context
    }
    
    func connectionClosed() {
        for (name, controller) in knownChannels {
            context?.removeViewController(controller, plugin: self)
        }
        knownChannels = [:]
    }
}
