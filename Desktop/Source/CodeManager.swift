//
//  CodeManager.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/22/15.
//
//

import Cocoa

enum CodeError : Error {
    case internalError
    case unknownPathExtension(URL)
    case unableToReadFile(URL, NSError)
    case descriptionNotFound
    case codeGenerationFailed(DLSEditor, NSCoding?)
    case unableToFindInitializer(String, URL) //"Couldn't find initializer for \"\(symbol)\" in \"\(url.lastPathComponent)\"")
    case tooManyMatches(String, URL)
    
    var message : String {
        switch self {
        case .internalError:
            return "Unexpected Internal Error. Sorry!"
        case let .unableToReadFile(url, error):
            return "Unable to read file \(url.path). Error: \(error)"
        case let .unknownPathExtension(url):
            let path = url.path
            return "Unknown file extension for file \"\(path)\". Expecting 'swift', 'h', 'm', or 'mm'"
        case .descriptionNotFound:
            return "Description Not Found"
        case let .codeGenerationFailed(editor, value):
            return "Couldn't generate code for \(String(describing: value)) using editor: \(type(of: editor))"
        case let .unableToFindInitializer(symbol, url):
            return "Couldn't find initializer for \"\(symbol)\" in \"\(url.lastPathComponent)\""
        case let .tooManyMatches(symbol, url):
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
class CodeManager: NSObject, CodeHelper {
    
    override init() {
        super.init()
    }
    
    private func languageForURL(_ url : URL) throws -> Language {
        if ["m", "mm", "h"].contains(url.pathExtension) {
            return .objC
        }
        else if url.pathExtension == "swift" {
            return .swift
        }
        else {
            throw CodeError.unknownPathExtension(url)
        }
    }
    
    private func loadFileAtURL(_ url : URL) throws -> String {
        do {
            let content = try String(contentsOf: url, encoding: String.Encoding.utf8)
            return content as String
        } catch let error as NSError {
            throw CodeError.unableToReadFile(url, error)
        }
    }
    
    func findSymbolWithName(_ name : String, inFileAtURL url : URL) throws -> String {
        let lang = try languageForURL(url)
        let content = try self.loadFileAtURL(url)
        let result = try self.findSymbolWithName(name, inString: content, ofLanguage : lang)
        return result
    }
    
    private func findSymbolWithPattern(_ pattern : String, inString code : String) throws -> String {
        let matcher = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
        guard let match = matcher.matches(in: code, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, code.characters.count)).first else {
            throw CodeError.descriptionNotFound
        }
        let range = match.rangeAt(1)
        let result = (code as NSString).substring(with: range).trimmingCharacters(in: CharacterSet(charactersIn: "\t\n\r &"))
        return result
    }
    
    func findSymbolWithName(_ name : String, inString code : String, ofLanguage lang : Language) throws -> String {
        let prefix : String
        switch lang {
        case .objC:
            prefix = "@"
        case .swift:
            prefix = ""
        }
        let escapedName = NSRegularExpression.escapedPattern(for: name)
        let pattern = "DLSControl\\([ ]*\(prefix)\"\(escapedName)\"[ ]*[^)]*.*Of\\(([^,\n)]*)"
        return try findSymbolWithPattern(pattern, inString: code)
    }
    
    func updateSymbol(_ symbol : String, toCode replacementCode: String, in lang: Language, at url: URL) throws {
        
        let pattern : String
        let template : String
        
        let escapedSymbol = NSRegularExpression.escapedPattern(for: symbol)
        switch lang {
        case .objC:
            pattern = "([\r\n ]+)(\(escapedSymbol))([\r\n ]*)=([\r\n ]*)(.*);"
            template = "$1$2$3=$4\(replacementCode);"
        case .swift:
            pattern = "([\r\n ]+)(\(escapedSymbol))(.*)([\r\n ]*)=([\r\n ]*)([^{}\r\n]*)"
            template = "$1$2$3$4=$5\(replacementCode)"
        }
        
        let code = try self.loadFileAtURL(url)
        let matcher = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options())
        let range = NSMakeRange(0, code.characters.count)
        let result = (code as NSString).mutableCopy() as! NSMutableString
        let replacementCount = matcher.replaceMatches(in: result, options: NSRegularExpression.MatchingOptions(), range: range, withTemplate: template)
        guard replacementCount != 0 else {
            throw CodeError.unableToFindInitializer(symbol, url)
        }
        guard replacementCount == 1 else {
            // TODO show an option picker
            throw CodeError.tooManyMatches(symbol, url)
        }
        try result.write(to: url, atomically : true, encoding: String.Encoding.utf8.rawValue)
    }
    
    func updateSymbol(_ symbol : String, toValue value : NSCoding?, with editor: DLSEditor, at url : URL) throws {
        let lang = try languageForURL(url)
        
        guard let generator = editor as? CodeGenerating else {
            throw CodeError.codeGenerationFailed(editor, value)
        }
        let replacementCode = generator.code(forValue: value, language: lang)
        
        try updateSymbol(symbol, toCode: replacementCode, in:lang, at: url)

    }
}
