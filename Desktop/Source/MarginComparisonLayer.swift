//
//  MarginComparisonLayer.swift
//  Dials
//
//  Created by Akiva Leffert on 7/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Foundation

extension CGRect {
    func horizontalIntersectionWithRect(_ rect : CGRect) -> CGFloat? {
        let testRect = CGRect(x: rect.origin.x, y: self.origin.y, width: rect.size.width, height: self.size.height)
        let intersection = testRect.intersection(self)
        if intersection.isNull {
            return nil
        }
        else {
            return intersection.midX
        }
    }
    
    func verticalIntersectionWithRect(_ rect : CGRect) -> CGFloat? {
        let testRect = CGRect(x: self.origin.x, y: rect.origin.y, width: self.size.width, height: rect.size.height)
        let intersection = testRect.intersection(self)
        if intersection.isNull {
            return nil
        }
        else {
            return intersection.midY
        }
    }
}

func average(_ l : CGFloat, _ r : CGFloat) -> CGFloat {
    return (l + r) / 2
}

// Assumes interval.0 < interval.1 and options.0 < options.1
func nearest(interval : (CGFloat, CGFloat), options : (CGFloat, CGFloat)) -> (CGFloat?, CGFloat?) {
    
    func filterEqual(_ a : CGFloat?, _ b : CGFloat?) -> (CGFloat?, CGFloat?) {
        var result = (a, b)
        if a == interval.0 {
            result.0 = nil
        }
        if b == interval.1 {
            result.1 = nil
        }
        return result
    }
    
    if options.0 < interval.0 {
        if options.1 < interval.0 {
            return filterEqual(options.1, nil)
        }
        else {
            return filterEqual(options.0, options.1)
        }
    }
    else {
        if options.0 > interval.1 {
            return filterEqual(nil, options.0)
        }
        else {
            return filterEqual(options.0, options.1)
        }
    }
}

class MarginComparisonLayer : CALayer {
    var comparison : ViewFacade?
    
    let topMargin = CAShapeLayer()
    let bottomMargin = CAShapeLayer()
    let leftMargin = CAShapeLayer()
    let rightMargin = CAShapeLayer()
    
    let topText = CATextLayer()
    let bottomText = CATextLayer()
    let leftText = CATextLayer()
    let rightText = CATextLayer()
    
    override init() {
        super.init()
        for margin in margins {
            addSublayer(margin)
            margin.lineWidth = 1
            margin.strokeColor = NSColor.orange.cgColor
        }
        
        for text in textLayers {
            addSublayer(text)
            text.font = NSFont.systemFont(ofSize: 18)
            text.fontSize = 18
            text.alignmentMode = kCAAlignmentCenter;
            text.foregroundColor = NSColor.white.cgColor
            text.backgroundColor = NSColor.darkGray.cgColor
            text.cornerRadius = 6
            text.masksToBounds = true
        }
    }
    
    override init(layer : Any) {
        super.init(layer : layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sizeLabelToFit(_ layer : CATextLayer) {
        let attributes : [String : AnyObject]
        if let font = layer.font {
            attributes = [NSFontAttributeName : font]
        }
        else {
            attributes = [:]
        }
        guard let string = layer.string as? NSString else {
            return
        }
        var size = string.size(withAttributes: attributes)
        
        size.width += 10
        
        layer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    var margins : [CAShapeLayer] {
        return [topMargin, bottomMargin, leftMargin, rightMargin]
    }
    
    var textLayers : [CATextLayer] {
        return [topText, bottomText, leftText, rightText]
    }
    
    func updateWithSelectionLayer(_ selection : ViewFacade?) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if let selection = selection, let comparison = comparison {
            let selectionFrame = selection.convert(selection.contentLayer.bounds, to:self)
            let comparisonFrame = comparison.convert(comparison.contentLayer.bounds, to:self)
            
            for margin in margins {
                margin.path = NSBezierPath().CGPath
            }
            
            for text in textLayers {
                text.isHidden = true
            }
            
            let cx = selectionFrame.horizontalIntersectionWithRect(comparisonFrame)
            let cy = selectionFrame.verticalIntersectionWithRect(comparisonFrame)
            
            let (topDest, bottomDest) = nearest(
                interval:(selectionFrame.minY, selectionFrame.maxY),
                options:(comparisonFrame.minY, comparisonFrame.maxY))
            
            let (leftDest, rightDest) = nearest(
                interval:(selectionFrame.minX, selectionFrame.maxX),
                options:(comparisonFrame.minX, comparisonFrame.maxX))
            
            let edges : [(CGFloat?, CAShapeLayer, CATextLayer, CGFloat, CGFloat?, CGFloat, (CGFloat, CGFloat) -> CGPoint)] = [
                (cx, topMargin, topText, selectionFrame.minY, topDest, -30 as CGFloat, CGPoint.init),
                (cx, bottomMargin, bottomText, selectionFrame.maxY, bottomDest, -30 as CGFloat, CGPoint.init),
                (cy, leftMargin, leftText, selectionFrame.minX, leftDest, -10 as CGFloat, {CGPoint(x: $1, y: $0)}),
                (cy, rightMargin, rightText, selectionFrame.maxX, rightDest, -10 as CGFloat, {CGPoint(x: $1, y: $0)})
            ]
            for (center, layer, label, source, dest, labelDelta, makePoint) in edges {
                if let c = center, let end = dest {
                    label.isHidden = false
                    label.string = "\(fabs(source - end))"
                    sizeLabelToFit(label)
                    label.position = makePoint(c + labelDelta, average(source, end))
                    
                    layer.path = NSBezierPath(
                        from: makePoint(c, source),
                        to: makePoint(c, end)).CGPath
                }
            }
        }
        CATransaction.commit()
    }
}
