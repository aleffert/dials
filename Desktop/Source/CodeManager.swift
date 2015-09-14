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

// In the mean time, we should at least replace some of this stuff with a relatively
// simple CFG parser
public class CodeManager: NSObject {
    
    private func languageForURL(path : NSURL) -> Result<Language> {
        if ["m", "mm", "h"].contains(path.pathExtension ?? "") {
            return Success(.ObjC)
        }
        else if path.pathExtension == "swift" {
            return Success(.Swift)
        }
        else {
            return Failure("Unknown file extensions: \(path.pathExtension)")
        }
    }
    
    private func loadFileAtURL(url : NSURL) -> Result<String> {
        do {
            let content = try NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
            return Success(content as String)
        } catch let e as NSError {
            return Failure(e.localizedDescription)
        }
    }
    
    public func findSymbolWithName(name : String, inFileAtURL url : NSURL) -> Result<String> {
        return languageForURL(url).bind {lang in
            let content = self.loadFileAtURL(url)
            return content.bind {
                self.findSymbolWithName(name, inString: $0, ofLanguage : lang)
            }
        }
    }
    
    private func findSymbolWithPattern(pattern : String, inString code : String) -> Result<String> {
        return NSRegularExpression.compile(pattern).bind {
            matcher in
            let options = NSMatchingOptions()
            let match: AnyObject? = matcher.matchesInString(code, options: options, range: NSMakeRange(0, code.characters.count)).first
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
    
    public func updateSymbol(symbol : String, toValue value : NSCoding?, withEditor editor: DLSEditor, atURL url : NSURL) -> Result<()> {
        // Swift needs monad syntax
        return languageForURL(url).bind {lang -> Result<String> in
            return self.loadFileAtURL(url).bind {code in
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
                        pattern = "([\r\n ]+)(\(escapedSymbol))(.*)([\r\n ]*)=([\r\n ]*)([^{}\r\n]*)"
                        template = "$1$2$3$4=$5\(replacementCode)"
                    }
                    
                    return NSRegularExpression.compile(pattern).bind {
                        let range = NSMakeRange(0, code.characters.count)
                        let result = (code as NSString).mutableCopy() as! NSMutableString
                        let replacementCount = $0.replaceMatchesInString(result, options: NSMatchingOptions(), range: range, withTemplate: template)
                        if replacementCount == 1 {
                            return Success(result as String)
                        }
                        else if replacementCount == 0 {
                            return Failure("Couldn't find initializer for \"\(symbol)\" in \"\(url.lastPathComponent)\"")
                        }
                        else {
                            // TODO show an option picker
                            return Failure("Too many matches for \"\(symbol)\" (\(replacementCount)) in \"\(url.lastPathComponent)\". Couldn't decide which to replace.")
                        }
                    }
                }
            }
        }.bind {r in
            do {
                try (r as NSString).writeToURL(url, atomically : true, encoding: NSUTF8StringEncoding)
                return Success(())
            } catch let e as NSError {
                return Failure(e.localizedDescription)
            }
        }
    }
}
