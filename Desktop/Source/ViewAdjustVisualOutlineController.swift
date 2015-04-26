//
//  ViewAdjustVisualOutlineController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/24/15.
//
//

import AppKit

class ViewFacade : CATransformLayer {
    let borderLayer = CALayer()
    let contentLayer = CALayer()
    var hierarchyDepth = 0
    
    var record : DLSViewHierarchyRecord!
    
    init(record : DLSViewHierarchyRecord) {
        self.record = record
        
        super.init()
        
        borderLayer.borderWidth = 1
        borderLayer.borderColor = NSColor.lightGrayColor().colorWithAlphaComponent(0.3).CGColor
        
        let layoutManager = CAConstraintLayoutManager.layoutManager() as! CAConstraintLayoutManager
        self.layoutManager = layoutManager
        
        addSublayer(borderLayer)
        addSublayer(contentLayer)
        
        borderLayer.addConstraintsMatchingSuperviewBounds(insets: NSEdgeInsets(top: -1, left: -1, bottom: 1, right: 1))
        
        contentLayer.addConstraintsMatchingSuperviewBounds()
    }
    
    override init(layer : AnyObject!) {
        super.init(layer : layer)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ViewAdjustVisualOutlineController: NSViewController, VisualOutlineControlsViewDelegate {
    @IBOutlet var contentView : NSView!
    private var layers : [NSString:ViewFacade] = [:]
    var hierarchy : ViewAdjustHierarchy!
    private let controlsView = VisualOutlineControlsView()
    private let bodyLayer = CATransformLayer()
    
    private var rotationOffset = NSZeroPoint
    private var activeOffset = NSZeroPoint
    
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
        
        let gesture = NSPanGestureRecognizer(target: self, action: Selector("pan:"))
        contentView.addGestureRecognizer(gesture)
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
    
    func controlsView(view: VisualOutlineControlsView, changedZoom zoomScale: CGFloat) {
        updateBodyTransforms()
    }
    
    func controlsView(view: VisualOutlineControlsView, changedDepth depth: CGFloat) {
        for layer in layers.values {
            layer.contentLayer.transform = CATransform3DMakeTranslation(0.0, 0.0, CGFloat(layer.hierarchyDepth) * depth)
            layer.borderLayer.transform = layer.contentLayer.transform
        }
    }
    
    func controlsViewResetTransform(view: VisualOutlineControlsView) {
        rotationOffset = NSZeroPoint
        updateBodyTransforms()
    }
    
    func offsetToRadians(v : CGFloat) -> CGFloat {
        return v / 90
    }
    
    func updateBodyTransforms() {
        // Scale comes in at [-1, 1]. Need to convert to [.5, 2] where f(0) = 0
        let zoomScale = controlsView.zoom
        let scale = zoomScale < 0 ? (zoomScale / 2 + 1) : (zoomScale + 1)
        let translate = CATransform3DMakeTranslation(-screenSize.width / 2, -screenSize.height / 2, 0)
        let scaleTransform = CATransform3DMakeScale(-scale, -scale, 1)
        let offset = CGPointMake(rotationOffset.x + activeOffset.x, rotationOffset.y + activeOffset.y)
        let xRotation = CATransform3DMakeRotation(offsetToRadians(offset.x), 0, 1, 0)
        let yRotation = CATransform3DMakeRotation(offsetToRadians(-offset.y), 1, 0, 0)
        let rotationTransform = CATransform3DConcat(xRotation, yRotation)
        bodyLayer.transform = CATransform3DConcat(CATransform3DConcat(translate, scaleTransform), rotationTransform)
    }
    
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
            
            if fabs(sin(offsetToRadians(rotationOffset.x))) < 0.6 && fabs(sin(offsetToRadians(rotationOffset.y / 90))) < 0.6 {
                rotationOffset = NSZeroPoint
                updateBodyTransforms()
            }
        default:
            break
        }
    }
}
