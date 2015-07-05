//
//  NSBezierPath+Helpers.swift
//  Dials
//
//  Created by Akiva Leffert on 7/5/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Foundation

extension NSBezierPath {
    
    convenience init(from : CGPoint, to : CGPoint) {
        self.init()
        moveToPoint(from)
        lineToPoint(to)
    }
    
    var CGPath : CGPathRef {
        var i = 0
        var numElements = self.elementCount
        let path = CGPathCreateMutable()
        if numElements > 0 {
            var closedPath = true
            var points = NSPointArray.alloc(3)
            for i in 0 ..< numElements {
                switch elementAtIndex(i, associatedPoints: points) {
                case .MoveToBezierPathElement:
                    CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
                case .LineToBezierPathElement:
                    CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
                case .CurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
                case .ClosePathBezierPathElement:
                    CGPathCloseSubpath(path)
                    closedPath = true
                }
            }
            
            if !closedPath {
                CGPathCloseSubpath(path)
            }
            
            points.destroy(3)
        }
        return path
    }
}
