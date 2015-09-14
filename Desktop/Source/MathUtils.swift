//
//  MathUtils.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/26/15.
//
//


import GLKit

typealias Vec3 = GLKVector3
typealias Mat4 = GLKMatrix4

extension CGRect {
    var max : CGPoint {
        return CGPoint(x : CGRectGetMaxX(self), y : CGRectGetMaxY(self))
    }
}

extension CATransform3D {
    var matrix4 : GLKMatrix4 {
        return GLKMatrix4Make(Float(m11), Float(m12), Float(m13), Float(m14), Float(m21), Float(m22), Float(m23), Float(m24), Float(m31), Float(m32), Float(m33), Float(m34), Float(m41), Float(m42), Float(m43), Float(m44))
    }
}

extension Vec3 {
    var xy : CGPoint {
        return CGPoint(x : CGFloat(x), y : CGFloat(y))
    }
    
    func offsetBy(dx dx : CGFloat = 0, dy : CGFloat = 0, dz : CGFloat = 0) -> Vec3 {
        return GLKVector3Make(x + Float(dx), y + Float(dy), z + Float(dz))
    }
    
    var cgx : CGFloat {
        return CGFloat(x)
    }
    
    var cgy : CGFloat {
        return CGFloat(y)
    }
    
    var cgz : CGFloat {
        return CGFloat(z)
    }
}

func * (left : Mat4, right : Vec3) -> Vec3 {
    return GLKMatrix4MultiplyVector3(left, right)
}

func * (left : CATransform3D, right : Vec3) -> Vec3 {
    return left.matrix4 * right
}

func clamp(value : CGFloat, min minValue : CGFloat, max maxValue : CGFloat) -> CGFloat {
    return min(max(value, minValue), maxValue)
}