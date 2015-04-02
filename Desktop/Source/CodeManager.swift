//
//  CodeManager.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

import Cocoa

// This is SUPER primitive. Hopefully some day the clang and swiftc libraries will
// be part of the system, but for now clang is a super heavy dependencies to be
// avoided and swiftc isn't useful

public class CodeManager: NSObject {
    
    private func branchWithFileName<A>(file : String, objcAction: String -> Result<A>, swiftAction : String -> Result<A>) -> Result<A> {
        var error : NSError?
        let content = NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding, error: &error)
        if let c = content {
            if file.pathExtension == "m" || file.pathExtension == "mm" {
                return objcAction(c)
            }
            else if file.pathExtension == "swift" {
                return swiftAction(c)
            }
            else {
                return .Failure("Unknown file extensions: \(file.pathExtension)")
            }
        }
        else {
            return .Failure(error?.localizedDescription ?? "Unknown Error loading file: \(file)")
        }
    }
    
    public func findSymbolWithName(name : String, inFile file : String) -> Result<String> {
        return branchWithFileName(file,
            objcAction: {c in
                self.findSymbolWithObjectiveCName(name, inString: c)
            }, swiftAction: {c in
                self.findSymbolWithSwiftName(name, inString: c)
            }
        )
    }
    
    private func findSymbolWithPattern(pattern : String, inString code : String) -> Result<String> {
        return NSRegularExpression.compile(pattern).bind {matcher in
            let options = NSMatchingOptions()
            let match: AnyObject? = matcher.matchesInString(code, options: options, range: NSMakeRange(0, countElements(code))).first
            return (match as? NSTextCheckingResult).toResult("Description not found")
            }.bind {(m : NSTextCheckingResult) in
            let range = m.rangeAtIndex(1)
            let result = (code as NSString).substringWithRange(range).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\t\n\r &"))
            return .Success(Box(result))
        }
    }
    
    public func findSymbolWithSwiftName(name : String, inString code : String) -> Result<String> {
        let pattern = NSString(format: "DLSAdd[A-Za-z]*Control\\([ ]*\"%@\"[ ]*,([^,\n]*).*\\)", NSRegularExpression.escapedPatternForString(name))
        return findSymbolWithPattern(pattern, inString: code)
    }
    
    public func findSymbolWithObjectiveCName(name : String, inString code : String) -> Result<String> {
        let pattern = NSString(format: "DLSAdd[A-Za-z]*Control\\([ ]*@\"%@\"[ ]*,([^,\n]*).*\\)", NSRegularExpression.escapedPatternForString(name))
        return findSymbolWithPattern(pattern, inString: code)
    }
    
    public func updateObjectiveCSymbol(symbol : String, toValue value : NSCoding?, withEditor editor: DLSEditorDescription, inString code : String) -> Result<String> {
        let pattern = NSString(format : "([\r\n ]+)(%@)([\r\n ]*)=([\r\n ]*)(.*);", NSRegularExpression.escapedPatternForString(symbol))
        let codeGenerator = (editor as? CodeGenerating).toResult("Cannot generate code")
        return codeGenerator.bind {generator in
                NSRegularExpression.compile(pattern).bind {
                let replacementCode = generator.objcCodeForValue(value)
                let template = NSString(format:"$1$2$3=$4%@;", NSRegularExpression.escapedTemplateForString(replacementCode))
                let range = NSMakeRange(0, countElements(code))
                let result = $0.stringByReplacingMatchesInString(code, options: NSMatchingOptions(), range: range, withTemplate: template)
                return .Success(Box(result))
            }
        }
    }
    
    func updateSwiftSymbol(symbol : String, toValue value : NSCoding?, withEditor editor : DLSEditorDescription, inString code : String) -> Result<String> {
        let pattern = NSString(format : "([\r\n ]+)(%@)(.*)([\r\n ]*)=([\r\n ]*)(.*)", NSRegularExpression.escapedPatternForString(symbol))
        let codeGenerator = (editor as? CodeGenerating).toResult("Cannot generate code")
        return codeGenerator.bind {generator in
            NSRegularExpression.compile(pattern).bind {
                let replacementCode = generator.swiftCodeForValue(value)
                let template = NSString(format:"$1$2$3$4=$5%@", NSRegularExpression.escapedTemplateForString(replacementCode))
                let range = NSMakeRange(0, countElements(code))
                let result = $0.stringByReplacingMatchesInString(code, options: NSMatchingOptions(), range: range, withTemplate: template)
                return .Success(Box(result))
            }
        }
    }
    
    public func updateSymbol(symbol : String, toValue value : NSCoding?, withEditor editor: DLSEditorDescription, inFile file : String) -> Result<()> {
        return branchWithFileName(file,
            objcAction: {code in
                self.updateObjectiveCSymbol(symbol, toValue: value, withEditor: editor, inString: code)
            }, swiftAction: {code in
                self.updateSwiftSymbol(symbol, toValue: value, withEditor: editor, inString:code)
            }
        ).bind {r in
            var error : NSError?
            (r as NSString).writeToFile(file, atomically : true, encoding: NSUTF8StringEncoding, error : &error)
            if let e = error {
                return .Failure(e.localizedDescription)
            }
            else {
                return .Success(Box(()))
            }
        }
    }
}
