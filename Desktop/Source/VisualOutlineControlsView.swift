//
//  VisualOutlineControlsView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/25/15.
//
//

import Cocoa

protocol VisualOutlineControlsViewDelegate : class {
    func controlsView(_ view : VisualOutlineControlsView, changedZoom zoomScale : CGFloat)
    func controlsView(_ view : VisualOutlineControlsView, changedDepth depth : CGFloat)
    func controlsViewResetTransform(_ view : VisualOutlineControlsView)
}

class VisualOutlineControlsView: NSView {
    @IBOutlet fileprivate var bodyView : NSView!
    @IBOutlet fileprivate var zoomSlider : NSSlider!
    @IBOutlet fileprivate var depthSlider : NSSlider!
    
    weak var delegate : VisualOutlineControlsViewDelegate?
    
    override init(frame frameRect: NSRect) {
        super.init(frame : frameRect)
        Bundle.main.loadNibNamed("VisualOutlineControlsView", owner: self, topLevelObjects: nil)
        addSubview(bodyView)
        bodyView.addConstraintsMatchingSuperviewBounds()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction fileprivate func zoomChanged(_ sender : NSSlider) {
        self.delegate?.controlsView(self, changedZoom: CGFloat(sender.floatValue))
    }
    
    @IBAction fileprivate func resetTransform(_ sender : AnyObject) {
        self.delegate?.controlsViewResetTransform(self)
    }
    
    @IBAction fileprivate func depthChanged(_ sender : NSSlider) {
        self.delegate?.controlsView(self, changedDepth: CGFloat(sender.floatValue))
    }
    
    @IBAction fileprivate func resetZoom(_ sender : AnyObject) {
        zoom = 1
        self.delegate?.controlsView(self, changedZoom: 1)
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
