//
//  Optional+Utilities.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Foundation

extension Optional {
    func bind<U>(f : T -> U?) -> U? {
        if let v = self {
            return f(v)
        }
        else {
            return nil
        }
    }
    
}