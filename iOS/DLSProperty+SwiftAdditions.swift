//
//  DLSProperty+SwiftAdditions.swift
//  Dials
//
//  Created by Akiva Leffert on 5/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import UIKit

func DLSProperty(name : String, label: String? = nil, editor : DLSEditor, _ exchanger : DLSValueExchanger? = nil) -> DLSPropertyDescription {
    let property = DLSProperty(name, editor)
    exchanger.map { property.setExchanger($0) }
    label.map { property.setLabel($0) }
    return property
}
