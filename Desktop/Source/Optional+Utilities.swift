//
//  Optional+Utilities.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Foundation

extension Optional {
    func ifValue(f : T -> Void) {
        if let v = self {
            f(v)
        }
    }
}
