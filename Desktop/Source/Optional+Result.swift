//
//  Optional+Result.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/23/15.
//
//

import Foundation

extension Optional {
    func toResult(failureString : String?) -> Result<Wrapped> {
        if let v = self {
            return Success(v)
        }
        else {
            return Failure(failureString ?? "Unknown Error")
        }
    }
}