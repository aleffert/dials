//
//  Dictionary+Utilties.swift
//  Dials
//
//  Created by Akiva Leffert on 5/23/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import Foundation

extension Dictionary {
    init(elements : [Element]) {
        self.init()
        for (key, value) in elements {
            self[key] = value
        }
    }
}