//
//  ViewAdjustVisualOutlineController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/24/15.
//
//

import AppKit
import GLKit


protocol ViewAdjustVisualOutlineControllerDelegate : class {
    func visualOutlineController(controller : ViewAdjustVisualOutlineController, selectedViewWithID  viewID: NSString?)
}

class ViewAdjustVisualOutlineController: NSViewController, VisualOutlineControlsViewDelegate {
    weak var delegate : ViewAdjustVisualOutlineControllerDelegate?
    
    @IBOutlet private var contentView : NSView!
    
    var hierarchy : ViewAdjustHierarchy!
    
    private var layers : [NSString:ViewFacade] = [:]
    private let controlsView = VisualOutlineControlsView()
    private let bodyLayer = CATransformLayer()
    
    private var rotationOffset = NSZeroPoint
    private var activeOffset = NSZeroPoint
    private var gestureMagnification : CGFloat = 1
    
    private var currentSelection : NSString?
    
    private var contents : [NSString:NSImage] = [:]
    
    var screenSize = CGSizeZero {
        didSet {
            updateBodyTransforms()
        }
    }
    
    override func viewDidLoad() {
        contentView.wantsLayer = true
        super.viewDidLoad()
        view.addSubview(controlsView)
        controlsView.addConstraintsMatchingSuperviewAttributes([.Bottom, .Left, .Right])
        controlsView.delegate = self
        
        contentView?.layer!.addSublayer(bodyLayer)
        
        updateBodyTransforms()
        
        let panGesture = NSPanGestureRecognizer(target: self, action: Selector("pan:"))
        contentView.addGestureRecognizer(panGesture)
        
        let zoomGesture = NSMagnificationGestureRecognizer(target : self, action : Selector("magnify:"))
        contentView.addGestureRecognizer(zoomGesture)
        
        let tapGesture = NSClickGestureRecognizer(target : self, action : Selector("click:"))
            contentView.addGestureRecognizer(tapGesture)
        
        let area = NSTrackingArea(rect: NSZeroRect, options: .ActiveInActiveApp | .MouseEnteredAndExited | .MouseMoved | .InVisibleRect, owner: self, userInfo: nil)
        contentView.addTrackingArea(area)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        bodyLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
    }
    
    private func visitNodes(nodes : [NSString], parent : CALayer, depth : Int, inout marking : Set<NSString>) {
        for node in nodes {
            if let record = hierarchy[node] {
                let layer = layers[node] ?? ViewFacade(record : record)
                layer.removeFromSuperlayer()
                layer.record = record
                marking.remove(node)
                layers[node] = layer
                parent.addSublayer(layer)
                
                layer.contentLayer.backgroundColor = record.renderingInfo.backgroundColor?.CGColor
                layer.contentLayer.borderColor = record.renderingInfo.borderColor?.CGColor
                layer.contentLayer.borderWidth = record.renderingInfo.borderWidth
                layer.bounds = record.renderingInfo.bounds
                layer.contentLayer.cornerRadius = record.renderingInfo.cornerRadius
                layer.contentLayer.opacity = Float(record.renderingInfo.opacity)
                layer.contentLayer.contents = contents[record.viewID]
                layer.position = record.renderingInfo.position
                layer.anchorPoint = record.renderingInfo.anchorPoint
                layer.transform = record.renderingInfo.transform3D
                layer.contentLayer.transform = CATransform3DMakeTranslation(0.0, 0.0, CGFloat(depth) * controlsView.depthOffset)
                layer.borderLayer.transform = layer.contentLayer.transform
                layer.hierarchyDepth = depth
                visitNodes(record.children as! [NSString], parent : layer, depth : depth + 1, marking: &marking)
            }
        }
    }
    
    func updateViews() {
        var unvisited = Set(layers.keys)
        visitNodes(hierarchy.roots, parent : bodyLayer, depth : 0, marking : &unvisited)
        for node in unvisited {
            if let layer = layers[node] {
                layer.removeFromSuperlayer()
                layers[node] = nil
            }
        }
    }
    
    func takeContents(contents : [NSString:NSData], empties : [NSString]) {
        for (key, imageData) in contents {
            self.contents[key] = NSImage(data: imageData)
        }
        for key in empties {
            self.contents[key] = nil
        }
        // TODO Garbage collect this
    }
    
    func offsetToRadians(v : CGFloat) -> CGFloat {
        return v / 90
    }
    
    func updateBodyTransforms() {
        let scale = gestureMagnification * controlsView.zoom
        let translate = CATransform3DMakeTranslation(-screenSize.width / 2, -screenSize.height / 2, 0)
        let scaleTransform = CATransform3DMakeScale(-scale, -scale, 1)
        let offset = CGPointMake(rotationOffset.x + activeOffset.x, rotationOffset.y + activeOffset.y)
        let xRotation = CATransform3DMakeRotation(offsetToRadians(offset.x), 0, 1, 0)
        let yRotation = CATransform3DMakeRotation(offsetToRadians(-offset.y), 1, 0, 0)
        let rotationTransform = CATransform3DConcat(xRotation, yRotation)
        bodyLayer.transform = CATransform3DConcat(CATransform3DConcat(translate, scaleTransform), rotationTransform)
    }
    
    func updateDepths(depth : CGFloat) {
        for layer in layers.values {
            layer.contentLayer.transform = CATransform3DMakeTranslation(0.0, 0.0, CGFloat(layer.hierarchyDepth) * depth)
            layer.borderLayer.transform = layer.contentLayer.transform
        }
    }
    
    func updateHighlights() {
        for layer in layers.values {
            if layer.record.viewID == self.currentSelection {
                layer.borderLayer.borderColor = BorderStyle.Selected.color.CGColor
            }
            else {
                layer.borderLayer.borderColor = BorderStyle.Normal.color.CGColor
            }
        }
    }
    
    func selectViewWithID(viewID : NSString?) {
        currentSelection = viewID
        updateHighlights()
    }
    
    // MARK: Gesture Handling
    
    func pan(sender : NSPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            fallthrough
        case .Changed:
            activeOffset = sender.translationInView(contentView)
            // Ideally we'd just reset the translation, but that seems to be buggy in AppKit
            updateBodyTransforms()
        case .Ended:
            rotationOffset.x = rotationOffset.x + activeOffset.x
            rotationOffset.y = rotationOffset.y + activeOffset.y
            activeOffset = NSZeroPoint
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            CATransaction.setAnimationDuration(0)
            updateBodyTransforms()
            CATransaction.commit()
            
            if fabs(sin(offsetToRadians(rotationOffset.x))) < 0.6 && fabs(sin(offsetToRadians(rotationOffset.y / 90))) < 0.6  && cos(offsetToRadians(rotationOffset.x)) > 0.9 && cos(offsetToRadians(rotationOffset.y)) > 0.9 {
                rotationOffset = NSZeroPoint
                updateBodyTransforms()
            }
        default:
            break
        }
    }
    
    func magnify(sender : NSMagnificationGestureRecognizer) {
        switch sender.state {
        case .Changed:
            gestureMagnification = 1 + sender.magnification
            updateBodyTransforms()
        case .Ended:
            controlsView.zoom = gestureMagnification * controlsView.zoom
            gestureMagnification = 1
            updateBodyTransforms()
        default:
            break
        }
    }
    
    func click(sender : NSClickGestureRecognizer) {
        let location = sender.locationInView(contentView)
        let layer = layerAtPointInContentView(location)
        
        self.delegate?.visualOutlineController(self, selectedViewWithID: layer?.record.viewID)
    }
    
    // MARK: Mouse Move Tracking
    
    private func firstLayerIntersectingRay(#pos : Vec3, neg : Vec3) -> ViewFacade? {
        updateHighlights()
        
        var best : ViewFacade?
        var bestDistance : CGFloat = CGFloat.max
        
        for layer in layers.values {
            let z = Float(layer.hierarchyDepth) * Float(controlsView.depthOffset)
            let pct = (z - neg.z) / (pos.z - neg.z)
            let x = CGFloat(pct * (pos.x - neg.x) + neg.x)
            let y = CGFloat(pct * (pos.y - neg.y) + neg.y)
            
            let topLeft = layer.convertPoint(layer.bounds.origin, toLayer : bodyLayer)
            let bottomRight = layer.convertPoint(layer.bounds.max, toLayer : bodyLayer)
            
            if x >= topLeft.x && x <= bottomRight.x && y >= topLeft.y && y <= bottomRight.y {
                // intersects. let's check distance
                let dx = pos.cgx - x
                let dy = pos.cgy - y
                let dz = pos.cgz - CGFloat(z)
                let distance = dx * dx + dy * dy + dz * dz
                if distance < bestDistance {
                    bestDistance = distance
                    best = layer
                }
            }
        }
        return best
    }
    
    private func layerAtPointInContentView(location : CGPoint) -> ViewFacade? {
        let endOfTheWorld : Float = 10000.0
        let layerLocation = contentView.convertPointToLayer(location)
        
        let locationOut = GLKVector3Make(Float(layerLocation.x - contentView.frame.size.width / 2), Float(layerLocation.y - contentView.frame.size.height / 2), endOfTheWorld)
        let transformedLocationOut = CATransform3DInvert(bodyLayer.transform) * locationOut
        var positionOut = transformedLocationOut.offsetBy(dx: screenSize.width / 2, dy: screenSize.height / 2)
        
        let locationIn = GLKVector3Make(Float(layerLocation.x - contentView.frame.size.width / 2), Float(layerLocation.y - contentView.frame.size.height / 2), -endOfTheWorld)
        let transformedLocationIn = CATransform3DInvert(bodyLayer.transform) * locationIn
        var positionIn = transformedLocationIn.offsetBy(dx: screenSize.width / 2, dy: screenSize.height / 2)
        
        return firstLayerIntersectingRay(pos : positionOut, neg : positionIn)
    }
    
    override func mouseMoved(theEvent: NSEvent) {
        let viewLocation = contentView.convertPoint(theEvent.locationInWindow, fromView: nil)
        
        if let layer = layerAtPointInContentView(viewLocation) {
            layer.borderLayer.borderColor = BorderStyle.Highlighted.color.CGColor
        }
    }
    
    override func mouseExited(theEvent: NSEvent) {
        updateHighlights()
    }
    
    // MARK: Controls View Delegate
    
    func controlsView(view: VisualOutlineControlsView, changedZoom zoomScale: CGFloat) {
        updateBodyTransforms()
    }
    
    func controlsView(view: VisualOutlineControlsView, changedDepth depth: CGFloat) {
        updateDepths(depth)
    }
    
    func controlsViewResetTransform(view: VisualOutlineControlsView) {
        rotationOffset = NSZeroPoint
        updateBodyTransforms()
    }
}
