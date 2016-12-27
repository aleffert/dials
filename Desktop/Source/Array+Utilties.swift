//
//  Array+Utilties.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Foundation

extension Array {
    // This should really return an Int? instead of a sentinel
    // but it caused a weird crash when using it. Seems like a compiler bug
    func indexOf(_ predicate : (Element) -> Bool) -> Int? {
        var i = 0
        for element in self {
            if predicate(element) {
                return i
            }
            i = i + 1
        }
        return nil
    }
    
    func indexed() -> [(Element, Int)] {
        var result : [(Element, Int)] = []
        var i = 0
        for e in self {
            let item = (e, i)
            result.append(item)
            i += 1
        }
        return result
    }
    
    func withPrevious() -> [(Element, Element?)] {
        var result : [(Element, Element?)] = []
        var prev : Element? = nil
        for e in self {
            let item = (e, prev)
            result.append(item)
            prev = e
        }
        return result
    }
}
