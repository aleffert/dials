//
//  CodeManagerTests.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

import Cocoa
import XCTest
@testable import Dials

extension Optional {
    func toResult(_ failureString : String) -> Result<Wrapped> {
        if let v = self {
            return Success(v)
        }
        else {
            return Failure(failureString)
        }
    }
}

class CodeManagerTests: XCTestCase {
    
    
    func sampleFileURLWithName(_ name : String) -> URL! {
        let url = URL(fileURLWithPath: name)
        let path = Bundle(for: CodeManagerTests.classForCoder()).url(forResource: url.deletingPathExtension().lastPathComponent, withExtension: url.pathExtension, subdirectory: "Sample Files")
        XCTAssertNotNil(path)
        return path
    }

    func testFindSymbolBasic() {
        let url = sampleFileURLWithName("find-name.m")
        do {
            let symbol = try CodeManager().findSymbolWithName("Description", inFileAtURL: url!)
            XCTAssertEqual(symbol, "SomeBoolean")
        }
        catch let e as NSError {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testFindSymbolArgumentsObjC() {
        let url = sampleFileURLWithName("find-name.m")
        do {
            let symbol = try CodeManager().findSymbolWithName("Other Content", inFileAtURL: url!)
            XCTAssertEqual(symbol, "SomeFloat")
        }
        catch let e as NSError {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testFindSymbolArgumentsSwiftBase() {
        do {
            let symbol = try CodeManager().findSymbolWithName("Test", inString: "DLSControl(\"Test\").colorOf(&foo)", ofLanguage: .swift)
            XCTAssertEqual(symbol, "foo")
        }
        catch let e as NSError {
            XCTFail(e.localizedDescription)
        }
    }
    
    func testFindSymbolArgumentsSwiftSpaceDots() {
        do {
            let symbol = try CodeManager().findSymbolWithName("Test", inString: "DLSControl(\"Test\") . colorOf(&foo)", ofLanguage: .swift)
            XCTAssertEqual(symbol, "foo")
        }
        catch let e as NSError {
            XCTFail(e.localizedDescription)
        }
    }
    
    
    func testReplace() {
        let url = sampleFileURLWithName("find-name.m")
        do {
            let symbol = try CodeManager().findSymbolWithName("Other Content", inFileAtURL: url!)
            XCTAssertEqual(symbol, "SomeFloat")
        }
        catch let e as NSError {
            XCTFail(e.localizedDescription)
        }
    }
}
