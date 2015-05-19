//
//  CodeManager.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

import Cocoa

public enum Language {
    case ObjC
    case Swift
}

// Finds symbols in code and replaces their assignment.
// This is SUPER primitive. Hopefully some day the clang and swiftc libraries will
// be part of the system, but for now clang is a super heavy dependency to be
// avoided and swiftc isn't useful for this
public class CodeManager: NSObject {
    
    private func languageForPath(path : String) -> Result<Language> {
        if path.pathExtension == "m" || path.pathExtension == "mm" || path.pathExtension == "h" {
            return Success(.ObjC)
        }
        else if path.pathExtension == "swift" {
            return Success(.Swift)
        }
        else {
            return Failure("Unknown file extensions: \(path.pathExtension)")
        }
    }
    
    private func loadFileAtPath(path : String) -> Result<String> {
        var error : NSError?
        let content = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: &error)
        return (content as String?).toResult(error?.localizedDescription)
    }
    
    public func findSymbolWithName(name : String, inFileAtPath path : String) -> Result<String> {
        return languageForPath(path).bind {lang in
            let content = self.loadFileAtPath(path)
            return content.bind {
                self.findSymbolWithName(name, inString: $0, ofLanguage : lang)
            }
        }
    }
    
    private func findSymbolWithPattern(pattern : String, inString code : String) -> Result<String> {
        return NSRegularExpression.compile(pattern).bind {matcher in
            let options = NSMatchingOptions()
            let match: AnyObject? = matcher.matchesInString(code, options: options, range: NSMakeRange(0, count(code))).first
            return (match as? NSTextCheckingResult).toResult("Description not found")
            }.bind {(m : NSTextCheckingResult) in
            let range = m.rangeAtIndex(1)
            let result = (code as NSString).substringWithRange(range).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\t\n\r &"))
            return Success(result)
        }
    }
    
    public func findSymbolWithName(name : String, inString code : String, ofLanguage lang : Language) -> Result<String> {
        let prefix : String
        switch lang {
        case .ObjC:
            prefix = "@"
        case .Swift:
            prefix = ""
        }
        let escapedName = NSRegularExpression.escapedPatternForString(name)
        let pattern = "DLSControl\\([ ]*\(prefix)\"\(escapedName)\"[ ]*[^)]*.*Of\\(([^,\n)]*)"
        return findSymbolWithPattern(pattern, inString: code)
    }
    
    public func updateSymbol(symbol : String, toValue value : NSCoding?, withEditor editor: DLSEditorDescription, atPath path : String) -> Result<()> {
        // Swift needs monad syntax
        return languageForPath(path).bind {lang -> Result<String> in
            return self.loadFileAtPath(path).bind {code in
                let escapedSymbol = NSRegularExpression.escapedPatternForString(symbol)
                
                let generator = (editor as? CodeGenerating).toResult("Cannot generate code")
                return generator.bind {
                    let replacementCode = $0.codeForValue(value, language: lang)
                    let pattern : String
                    let template : String
                    
                    switch lang {
                    case .ObjC:
                        pattern = "([\r\n ]+)(\(escapedSymbol))([\r\n ]*)=([\r\n ]*)(.*);"
                        template = "$1$2$3=$4\(replacementCode);"
                    case .Swift:
                        pattern = "([\r\n ]+)(\(escapedSymbol))(.*)([\r\n ]*)=([\r\n ]*)(.*)"
                        template = "$1$2$3$4=$5\(replacementCode)"
                    }
                    
                    return NSRegularExpression.compile(pattern).bind {
                        let range = NSMakeRange(0, count(code))
                        var result = (code as NSString).mutableCopy() as! NSMutableString
                        let replacementCount = $0.replaceMatchesInString(result, options: NSMatchingOptions(), range: range, withTemplate: template)
                        if replacementCount == 1 {
                            return Success(result as String)
                        }
                        else if replacementCount == 0 {
                            return Failure("Couldn't find initializer for \"\(symbol)\" in \"\(path.lastPathComponent)\"")
                        }
                        else {
                            return Failure("Too many matches for \"\(symbol)\" (\(replacementCount)) in \"\(path.lastPathComponent)\". Couldn't decide which to replace.")
                        }
                    }
                }
            }
        }.bind {r in
            var error : NSError?
            (r as NSString).writeToFile(path, atomically : true, encoding: NSUTF8StringEncoding, error : &error)
            if let e = error {
                return Failure(e.localizedDescription)
            }
            else {
                return Success(())
            }
        }
    }
}
