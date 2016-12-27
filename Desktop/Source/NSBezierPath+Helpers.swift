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
        move(to: from)
        line(to: to)
    }
    
    var CGPath : CGPath {
        let numElements = self.elementCount
        let path = CGMutablePath()
        if numElements > 0 {
            var closedPath = true
            let points = NSPointArray.allocate(capacity: 3)
            
            for i in 0 ..< numElements {
                switch element(at: i, associatedPoints: points) {
                case .moveToBezierPathElement:
                    path.move(to: points[0], transform: CGAffineTransform.identity)
                case .lineToBezierPathElement:
                    path.addLine(to: points[0], transform: CGAffineTransform.identity)
                case .curveToBezierPathElement:
                    path.addCurve(to: points[0], control1: points[1], control2: points[2])
                case .closePathBezierPathElement:
                    path.closeSubpath()
                    closedPath = true
                }
            }
            
            if !closedPath {
                path.closeSubpath()
            }
            
            points.deinitialize(count: 3)
        }
        return path
    }
}
