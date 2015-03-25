//
//  CodeManagerTests.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

import Cocoa
import XCTest
import Dials

extension Optional {
    func toResult(failureString : String) -> Result<T> {
        if let v = self {
            return .Success(Box(v))
        }
        else {
            return .Failure(failureString)
        }
    }
}

class CodeManagerTests: XCTestCase {
    
    func sampleFilePathWithName(name : String) -> Result<String> {
        let path = NSBundle(forClass: CodeManagerTests.classForCoder()).pathForResource(name.stringByDeletingPathExtension, ofType: name.pathExtension, inDirectory: "Sample Files")
        XCTAssertNotNil(path)
        return path.toResult("Could not find file: \(name)")
    }
    
    func testFindSymbolBasic() {
        let path = sampleFilePathWithName("find-name.m")
        path.bind {
            return CodeManager().findSymbolWithName("Description", inFile: $0)
        }.ifSuccess {(s : String) in
            XCTAssertEqual(s, "SomeBoolean")
        }.ifFailure {
            XCTFail($0)
        }
    }
    
    func testFindSymbolArguments() {
        let path = sampleFilePathWithName("find-name.m")
        path.bind {
            CodeManager().findSymbolWithName("Other Content", inFile: $0)
            }.ifSuccess {
                XCTAssertEqual($0, "SomeFloat")
            }.ifFailure {
                XCTFail($0)
        }
    }
    
    
    func testReplace() {
        let path = sampleFilePathWithName("find-name.m")
        path.bind {
            CodeManager().findSymbolWithName("Other Content", inFile: $0)
            }.ifSuccess {
                XCTAssertEqual($0, "SomeFloat")
            }.ifFailure {
                XCTFail($0)
        }
    }
}
