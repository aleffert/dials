//
//  MarginComparisonLayer.swift
//  Dials
//
//  Created by Akiva Leffert on 7/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Foundation

extension CGRect {
    func horizontalIntersectionWithRect(rect : CGRect) -> CGFloat? {
        let testRect = CGRectMake(rect.origin.x, self.origin.y, rect.size.width, self.size.height)
        let intersection = CGRectIntersection(testRect, self)
        if CGRectIsNull(intersection) {
            return nil
        }
        else {
            return CGRectGetMidX(intersection)
        }
    }
    
    func verticalIntersectionWithRect(rect : CGRect) -> CGFloat? {
        let testRect = CGRectMake(self.origin.x, rect.origin.y, self.size.width, rect.size.height)
        let intersection = CGRectIntersection(testRect, self)
        if CGRectIsNull(intersection) {
            return nil
        }
        else {
            return CGRectGetMidY(intersection)
        }
    }
}

func average(l : CGFloat, r : CGFloat) -> CGFloat {
    return (l + r) / 2
}

// Assumes interval.0 < interval.1 and options.0 < options.1
func nearest(#interval : (CGFloat, CGFloat), #options : (CGFloat, CGFloat)) -> (CGFloat?, CGFloat?) {
    if options.0 < interval.0 {
        if options.1 < interval.0 {
            return (options.1, nil)
        }
        else {
            return (options.0, options.1)
        }
    }
    else {
        if options.0 > interval.1 {
            return (nil, options.0)
        }
        else {
            return (options.0, options.1)
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
            margin.strokeColor = NSColor.orangeColor().CGColor
        }
        
        for text in textLayers {
            addSublayer(text)
            text.bounds = CGRectMake(0, 0, 200, 25)
            text.shadowColor = NSColor.whiteColor().CGColor
            text.shadowRadius = 2
            text.shadowOpacity = 1
            text.shadowOffset = CGSizeZero
            text.font = NSFont.systemFontOfSize(18)
            text.fontSize = 18
            text.alignmentMode = kCAAlignmentCenter;
            text.foregroundColor = NSColor.darkGrayColor().CGColor
        }
    }
    
    override init(layer : AnyObject!) {
        super.init(layer : layer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var margins : [CAShapeLayer] {
        return [topMargin, bottomMargin, leftMargin, rightMargin]
    }
    
    var textLayers : [CATextLayer] {
        return [topText, bottomText, leftText, rightText]
    }
    
    func updateWithSelectionLayer(selection : ViewFacade?) {
        if let selection = selection, comparison = comparison {
            let selectionFrame = selection.convertRect(selection.contentLayer.bounds, toLayer:self)
            let comparisonFrame = comparison.convertRect(comparison.contentLayer.bounds, toLayer:self)
            
            for margin in margins {
                margin.path = NSBezierPath().CGPath
            }
            
            for text in textLayers {
                text.hidden = true
            }
            
            let cx = selectionFrame.horizontalIntersectionWithRect(comparisonFrame)
            let cy = selectionFrame.verticalIntersectionWithRect(comparisonFrame)
            
            let (topDest, bottomDest) = nearest(
                interval:(selectionFrame.minY, selectionFrame.maxY),
                options:(comparisonFrame.minY, comparisonFrame.maxY))
            
            let (leftDest, rightDest) = nearest(
                interval:(selectionFrame.minX, selectionFrame.maxX),
                options:(comparisonFrame.minX, comparisonFrame.maxX))
            
            let edges = [
                (cx, topMargin, topText, selectionFrame.minY, topDest, -30 as CGFloat, CGPointMake),
                (cx, bottomMargin, bottomText, selectionFrame.maxY, bottomDest, -30 as CGFloat, CGPointMake),
                (cy, leftMargin, leftText, selectionFrame.minX, leftDest, -10 as CGFloat, {CGPointMake($1, $0)}),
                (cy, rightMargin, rightText, selectionFrame.maxX, rightDest, -10 as CGFloat, {CGPointMake($1, $0)})
            ]
            for (center, layer, label, source, dest, labelDelta, makePoint) in edges {
                if let c = center, end = dest {
                    label.hidden = false
                    label.position = makePoint(c + labelDelta, average(source, end))
                    label.string = "\(fabs(source - end))"
                    layer.path = NSBezierPath(
                        from: makePoint(c, source),
                        to: makePoint(c, end)).CGPath
                }
            }
        }
    }
}