//
//  Array+Utilties.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/21/15.
//
//

import Foundation

extension Array {
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
}