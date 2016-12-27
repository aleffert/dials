//
//  DLSProperty+SwiftAdditions.swift
//  Dials
//
//  Created by Akiva Leffert on 5/24/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import UIKit

func DLSProperty(_ name : String, label: String? = nil, editor : DLSEditor, _ exchanger : DLSValueExchanger? = nil) -> DLSPropertyDescription {
    let property = DLSProperty(name, editor)
    if let exchanger = exchanger { let _ = property.setExchanger(exchanger) }
    if let label = label { let _ = property.setLabel(label) }
    return property
}
