//
//  Array+Utilties.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Foundation

extension Array {
    // This should really return an Int? instead of a sentinal
    // but it caused a weird crash when using it. Seems like a compiler bug
    func indexOf(predicate : T -> Bool) -> Int {
        var i = 0
        for element in self {
            if predicate(element) {
                return i
            }
            i = i + 1
        }
        return NSNotFound
    }
}