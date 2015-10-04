//
//  CodeManager.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

import Cocoa

enum CodeError : ErrorType {
    case InternalError
    case UnknownPathExtension(NSURL)
    case UnableToReadFile(NSURL, NSError)
    case DescriptionNotFound
    case CodeGenerationFailed(DLSEditor, NSCoding?)
    case UnableToFindInitializer(String, NSURL) //"Couldn't find initializer for \"\(symbol)\" in \"\(url.lastPathComponent)\"")
    case TooManyMatches(String, NSURL)
    
    var message : String {
        switch self {
        case .InternalError:
            return "Unexpected Internal Error. Sorry!"
        case let .UnableToReadFile(url, error):
            return "Unable to read file \(url.path). Error: \(error)"
        case let .UnknownPathExtension(url):
            let path = url.path ?? "Internal Error"
            return "Unknown file extension for file \"\(path)\". Expecting 'swift', 'h', 'm', or 'mm'"
        case .DescriptionNotFound:
            return "Description Not Found"
        case let .CodeGenerationFailed(editor, value):
            return "Couldn't generate code for \(value) using editor: \(editor.dynamicType)"
        case let .UnableToFindInitializer(symbol, url):
            return "Couldn't find initializer for \"\(symbol)\" in \"\(url.lastPathComponent)\""
        case let .TooManyMatches(symbol, url):
            return "Too many matches for \"\(symbol)\" in \"\(url.lastPathComponent)\". Couldn't decide which to replace."
        }
    }
}

// Finds symbols in code and replaces their assignment.
// This is SUPER primitive. Hopefully some day the clang and swiftc libraries will
// be part of the system, but for now clang is a super heavy dependency to be
// avoided and swiftc isn't useful for this

// In the mean time, we should at least replace some of this stuff with a relatively
// simple CFG parser
public class CodeManager: NSObject, CodeHelper {
    
    private func languageForURL(url : NSURL) throws -> Language {
        if ["m", "mm", "h"].contains(url.pathExtension ?? "") {
            return .ObjC
        }
        else if url.pathExtension == "swift" {
            return .Swift
        }
        else {
            throw CodeError.UnknownPathExtension(url)
        }
    }
    
    private func loadFileAtURL(url : NSURL) throws -> String {
        do {
            let content = try NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
            return content as String
        } catch let error as NSError {
            throw CodeError.UnableToReadFile(url, error)
        }
    }
    
    public func findSymbolWithName(name : String, inFileAtURL url : NSURL) throws -> String {
        let lang = try languageForURL(url)
        let content = try self.loadFileAtURL(url)
        let result = try self.findSymbolWithName(name, inString: content, ofLanguage : lang)
        return result
    }
    
    private func findSymbolWithPattern(pattern : String, inString code : String) throws -> String {
        let matcher = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions())
        guard let match = matcher.matchesInString(code, options: NSMatchingOptions(), range: NSMakeRange(0, code.characters.count)).first else {
            throw CodeError.DescriptionNotFound
        }
        let range = match.rangeAtIndex(1)
        let result = (code as NSString).substringWithRange(range).stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\t\n\r &"))
        return result
    }
    
    public func findSymbolWithName(name : String, inString code : String, ofLanguage lang : Language) throws -> String {
        let prefix : String
        switch lang {
        case .ObjC:
            prefix = "@"
        case .Swift:
            prefix = ""
        }
        let escapedName = NSRegularExpression.escapedPatternForString(name)
        let pattern = "DLSControl\\([ ]*\(prefix)\"\(escapedName)\"[ ]*[^)]*.*Of\\(([^,\n)]*)"
        return try findSymbolWithPattern(pattern, inString: code)
    }
    
    public func updateSymbol(symbol : String, toCode replacementCode: String, inLanguage lang: Language, atURL url: NSURL) throws {
        
        let pattern : String
        let template : String
        
        let escapedSymbol = NSRegularExpression.escapedPatternForString(symbol)
        switch lang {
        case .ObjC:
            pattern = "([\r\n ]+)(\(escapedSymbol))([\r\n ]*)=([\r\n ]*)(.*);"
            template = "$1$2$3=$4\(replacementCode);"
        case .Swift:
            pattern = "([\r\n ]+)(\(escapedSymbol))(.*)([\r\n ]*)=([\r\n ]*)([^{}\r\n]*)"
            template = "$1$2$3$4=$5\(replacementCode)"
        }
        
        let code = try self.loadFileAtURL(url)
        let matcher = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions())
        let range = NSMakeRange(0, code.characters.count)
        let result = (code as NSString).mutableCopy() as! NSMutableString
        let replacementCount = matcher.replaceMatchesInString(result, options: NSMatchingOptions(), range: range, withTemplate: template)
        guard replacementCount != 0 else {
            throw CodeError.UnableToFindInitializer(symbol, url)
        }
        guard replacementCount == 1 else {
            // TODO show an option picker
            throw CodeError.TooManyMatches(symbol, url)
        }
        try result.writeToURL(url, atomically : true, encoding: NSUTF8StringEncoding)
    }
    
    public func updateSymbol(symbol : String, toValue value : NSCoding?, withEditor editor: DLSEditor, atURL url : NSURL) throws {
        let lang = try languageForURL(url)
        
        guard let generator = editor as? CodeGenerating else {
            throw CodeError.CodeGenerationFailed(editor, value)
        }
        let replacementCode = generator.codeForValue(value, language: lang)
        
        try updateSymbol(symbol, toCode: replacementCode, inLanguage:lang, atURL: url)

    }
}
