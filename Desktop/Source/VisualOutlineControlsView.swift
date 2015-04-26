//
//  VisualOutlineControlsView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/25/15.
//
//

import Cocoa

protocol VisualOutlineControlsViewDelegate : class {
    func controlsView(view : VisualOutlineControlsView, changedZoom zoomScale : CGFloat)
    func controlsView(view : VisualOutlineControlsView, changedDepth depth : CGFloat)
    func controlsViewResetTransform(view : VisualOutlineControlsView)
}

class VisualOutlineControlsView: NSView {
    @IBOutlet private var bodyView : NSView!
    @IBOutlet private var zoomSlider : NSSlider!
    @IBOutlet private var depthSlider : NSSlider!
    
    weak var delegate : VisualOutlineControlsViewDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame : frameRect)
        NSBundle.mainBundle().loadNibNamed("VisualOutlineControlsView", owner: self, topLevelObjects: nil)
        addSubview(bodyView)
        bodyView.addConstraintsMatchingSuperviewBounds()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction private func zoomChanged(sender : NSSlider) {
        self.delegate?.controlsView(self, changedZoom: CGFloat(sender.floatValue))
    }
    
    @IBAction private func resetTransform(sender : AnyObject) {
        self.delegate?.controlsViewResetTransform(self)
    }
    
    @IBAction private func depthChanged(sender : NSSlider) {
        self.delegate?.controlsView(self, changedDepth: CGFloat(sender.floatValue))
    }
    
    var zoom : CGFloat {
        get {
            // Scale comes in at [-1, 1]. Need to convert to [.5, 2] where f(0) = 0
            let zoomScale = self.zoomSlider.floatValue
            return CGFloat(zoomScale < 0 ? (zoomScale / 2 + 1) : (zoomScale + 1))
        }
        set(scale) {
            let value = scale > 1 ? scale - 1 : (scale - 1) * 2
            self.zoomSlider.floatValue = Float(value)
        }
    }
    
    var depthOffset : CGFloat {
        return CGFloat(self.depthSlider.floatValue)
    }
    
}
