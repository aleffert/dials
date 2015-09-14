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
    func toResult(failureString : String) -> Result<Wrapped> {
        if let v = self {
            return Success(v)
        }
        else {
            return Failure(failureString)
        }
    }
}

class CodeManagerTests: XCTestCase {
    
    func sampleFileURLWithName(name : String) -> Result<NSURL> {
        let url = NSURL(fileURLWithPath: name)
        let path = NSBundle(forClass: CodeManagerTests.classForCoder()).URLForResource(url.URLByDeletingPathExtension?.lastPathComponent, withExtension: url.pathExtension, subdirectory: "Sample Files")
        XCTAssertNotNil(path)
        return path.toResult("Could not find file: \(name)")
    }

    func testFindSymbolBasic() {
        let path = sampleFileURLWithName("find-name.m")
        path.bind {
            return CodeManager().findSymbolWithName("Description", inFileAtURL: $0)
        }.ifSuccess {(s : String) in
            XCTAssertEqual(s, "SomeBoolean")
        }.ifFailure {
            XCTFail($0)
        }
    }
    
    func testFindSymbolArgumentsObjC() {
        let path = sampleFileURLWithName("find-name.m")
        path.bind {
            CodeManager().findSymbolWithName("Other Content", inFileAtURL: $0)
            }.ifSuccess {
                XCTAssertEqual($0, "SomeFloat")
            }.ifFailure {
                XCTFail($0)
        }
    }
    
    func testFindSymbolArgumentsSwiftBase() {
        let symbol = CodeManager().findSymbolWithName("Test", inString: "DLSControl(\"Test\").colorOf(&foo)", ofLanguage: .Swift)
        XCTAssertEqual(symbol.value ?? "", "foo", symbol.error ?? "Unknown Error")
    }
    
    func testFindSymbolArgumentsSwiftSpaceDots() {
        let symbol = CodeManager().findSymbolWithName("Test", inString: "DLSControl(\"Test\") . colorOf(&foo)", ofLanguage: .Swift)
        XCTAssertEqual(symbol.value ?? "", "foo", symbol.error ?? "Unknown Error")
    }
    
    
    func testReplace() {
        let path = sampleFileURLWithName("find-name.m")
        path.bind {
            CodeManager().findSymbolWithName("Other Content", inFileAtURL: $0)
            }.ifSuccess {
                XCTAssertEqual($0, "SomeFloat")
            }.ifFailure {
                XCTFail($0)
        }
    }
}
