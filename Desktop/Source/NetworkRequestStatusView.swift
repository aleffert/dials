//
//  NetworkRequestStatusView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/6/15.
//
//

import Cocoa

class NetworkRequestStatusGroupViewOwner : NSObject {
    @IBOutlet var view : NetworkRequestStatusGroupView!
}

class NetworkRequestStatusGroupView : NSView {
    @IBOutlet var contentLabel : NSTextField!
}

private func sortHeaderMap(map : [NSObject : AnyObject]) -> [(String, String)] {
    let elements = (map as? [String:String] ?? [:])
    let pairs = elements.sort { $0.0 < $1.0 }
    return pairs
}

extension NSURLRequest {
    var sortedHeaders : [(String, String)] {
        return sortHeaderMap(allHTTPHeaderFields ?? [:])
    }
}

extension NSURLResponse {
    var sortedHeaders : [(String, String)] {
        return sortHeaderMap( (self as? NSHTTPURLResponse)?.allHeaderFields ?? [:])
    }
}

class NetworkRequestStatusView: NSView {
    typealias DataExtractor = NetworkRequestInfo -> [(String, NSAttributedString)]
    
    @IBOutlet var contentView : NSView!
    @IBOutlet var stackView : NSStackView!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        NSBundle.mainBundle().loadNibNamed("NetworkRequestStatusView", owner: self, topLevelObjects: nil)
        addSubview(contentView)
        contentView.addConstraintsMatchingSuperviewBounds()
    }
    
    static func formatPairs(pairs : [(String, String)]) -> NSAttributedString {
        let result = NSMutableAttributedString()
        for (key, value) in pairs {
            if result.length > 0 {
                result.appendAttributedString(NSAttributedString(string: "\n"))
            }
            result.appendAttributedString(NSAttributedString(string : key, attributes : [
                NSFontAttributeName : NSFont.boldSystemFontOfSize(10)
                ]))
            result.appendAttributedString(NSAttributedString(string : "\t"))
            result.appendAttributedString(NSAttributedString(string : value, attributes : [
                NSFontAttributeName : NSFont.systemFontOfSize(10)
                ]))
        }
        return result
    }
    
    private static func requestMessageFields(info : NetworkRequestInfo) -> [(String, String)] {
        var fields : [(String, String)] = []
        
        if let URL = info.request.URL {
            let field = ("URL", URL.absoluteString)
            fields.append(field)
        }
        
        fields.appendContentsOf([
            ("Start Date", info.startTime.preciseDateString),
            ("End Date", info.endTime?.preciseDateString ?? "In Progress")
        ])
        
        if let method = info.request.HTTPMethod {
            let field = ("Method", method)
            fields.append(field)
        }
        
        if let end = info.endTime {
            let field = ("Duration", "\(Int(end.timeIntervalSinceReferenceDate * 1000 - info.startTime.timeIntervalSinceReferenceDate * 1000))ms")
            fields.append(field)
        }
        
        if let size = info.request.HTTPBody?.length {
            let field = ("Size", "\(size) bytes")
            fields.append(field)
        }
        return fields
    }
    
    static func requestDataExtractor(info : NetworkRequestInfo) -> [(String, NSAttributedString)] {
        return [
            ("Message", formatPairs(requestMessageFields(info))),
            ("Headers", formatPairs(info.request.sortedHeaders))
        ]
    }
    
    
    private static func responseMessageFields(info : NetworkRequestInfo) -> [(String, String)]? {
        var fields : [(String, String)] = []
        if let response = info.response as? NSHTTPURLResponse {
            let field = ("Status", "\(response.statusCode) (\(response.statusCodeDescription))")
            fields.append(field)
        }
        if let size = info.data?.length {
            let field = ("Size", "\(size) bytes")
            fields.append(field)
        }
        return fields.count > 0 ? fields : nil
    }
    
    static func responseDataExtractor(info : NetworkRequestInfo) -> [(String, NSAttributedString)] {
        var elements : [(String, NSAttributedString)] = []
        if let response = info.response {
            let headers = response.sortedHeaders
            let pair = ("Headers", formatPairs(headers))
            elements.append(pair)
        }
        if let error = info.error {
            let pair = ("Error", formatPairs([
                ("Code", "\(error.code)"),
                ("Domain", error.domain),
                ("Description", error.localizedDescription)
                ]))
            elements.append(pair)
        }
        
        if let messageFields = responseMessageFields(info) {
            let pair = ("Message", formatPairs(messageFields))
            elements.append(pair)
        }
        
        return elements
    }
    
    var dataExtractor : DataExtractor = {_ in [] }
    
    var requestInfo : NetworkRequestInfo? {
        didSet {
            let data = requestInfo.map { self.dataExtractor($0) } ?? []
            while stackView.views.count > data.count {
                guard let view = stackView.views.last else {
                    break
                }
                stackView.removeView(view)
            }
            while stackView.views.count < data.count {
                let owner = NetworkRequestStatusGroupViewOwner()
                NSBundle.mainBundle().loadNibNamed("NetworkRequestStatusGroupView", owner: owner, topLevelObjects: nil)
                let body = owner.view
                
                let groupView = GroupContainerView(frame: CGRectZero)
                groupView.translatesAutoresizingMaskIntoConstraints = false
                groupView.contentView = body
                stackView.addView(groupView, inGravity: .Top)
            }
            
            for ((title, content), view) in zip(data, stackView.views as! [GroupContainerView]) {
                view.title = title
                let groupView = view.contentView as! NetworkRequestStatusGroupView
                groupView.contentLabel.attributedStringValue = content
            }
        }
    }
}
