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
    func indexOf(predicate : T -> Bool) -> Int? {
        var i = 0
        for element in self {
            if predicate(element) {
                return i
            }
            i = i + 1
        }
        return nil
    }
    
    func indexed() -> [(T, Int)] {
        var result : [(T, Int)] = []
        var i = 0
        for e in self {
            let item = (e, i)
            result.append(item)
            i++
        }
        return result
    }
    
    func withPrevious() -> [(T, T?)] {
        var result : [(T, T?)] = []
        var prev : T? = nil
        for e in self {
            let item = (e, prev)
            result.append(item)
            prev = e
        }
        return result
    }
}