//
//  RequestContentTabController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/13/15.
//
//

import Cocoa

struct RequestDataExtractor {
    let metadataExtractor : NetworkRequestInfo -> [(String, NSAttributedString)]
    let contentTypeExtractor : NetworkRequestInfo -> String?
    let dataExtractor : NetworkRequestInfo -> NSData?
}

class RequestContentTabController: NSObject {
    
    @IBOutlet var statusView : NetworkRequestStatusView!
    @IBOutlet var tabView : NSTabView!
    
    @IBOutlet var hexItem : NSTabViewItem!
    @IBOutlet var textItem : NSTabViewItem!
    @IBOutlet var imageItem : NSTabViewItem!
    
    @IBOutlet var hexView : NSTextView!
    @IBOutlet var textView : NSTextView!
    @IBOutlet var imageView : NSImageView!
    
    override func awakeFromNib() {
        hexView.font = NSFont(name: "Menlo", size: 11.0)
        hexView.enclosingScrollView?.horizontalScrollElasticity = .None
        textView.enclosingScrollView?.horizontalScrollElasticity = .None
    }
    
    var dataExtractor : RequestDataExtractor =
        RequestDataExtractor(
            metadataExtractor: {_ in return []},
            contentTypeExtractor: {_ in nil},
            dataExtractor: {_ in nil}
        )
        {
        didSet {
            statusView.dataExtractor = dataExtractor.metadataExtractor
        }
    }
    
    private static func requestContentTypeExtractor(info: NetworkRequestInfo) -> String? {
        let map = info.request.allHTTPHeaderFields
        return map?["Content-Type"]
    }
    
    private static func requestDataExtractor(info : NetworkRequestInfo) -> NSData? {
        return info.request.HTTPBody
    }
    
    static let requestDataExtractor : RequestDataExtractor = RequestDataExtractor(
        metadataExtractor: NetworkRequestStatusView.requestDataExtractor,
        contentTypeExtractor: RequestContentTabController.requestContentTypeExtractor,
        dataExtractor: RequestContentTabController.requestDataExtractor
    )
    
    private static func responseContentTypeExtractor(info: NetworkRequestInfo) -> String? {
        let map = (info.response as? NSHTTPURLResponse)?.allHeaderFields as? [String:String]
        return map?["Content-Type"]
    }
    
    private static func responseDataExtractor(info : NetworkRequestInfo) -> NSData? {
        return info.data
    }
    
    static let responseDataExtractor : RequestDataExtractor = RequestDataExtractor(
        metadataExtractor: NetworkRequestStatusView.responseDataExtractor,
        contentTypeExtractor: RequestContentTabController.responseContentTypeExtractor,
        dataExtractor: RequestContentTabController.responseDataExtractor
    )
    
    private func addTabViewItem(item : NSTabViewItem) {
        if !(tabView.tabViewItems as NSArray).containsObject(item) {
            self.tabView.addTabViewItem(item)
        }
    }
    
    private func removeTabViewItem(item : NSTabViewItem) {
        if (tabView.tabViewItems as NSArray).containsObject(item) {
            self.tabView.removeTabViewItem(item)
        }
    }
    
    var requestInfo : NetworkRequestInfo? {
        didSet {
            statusView.requestInfo = requestInfo
            let contentType = requestInfo.flatMap { dataExtractor.contentTypeExtractor($0) }
            
            if let data = requestInfo.flatMap({ dataExtractor.dataExtractor($0) }) {
                addTabViewItem(hexItem)
                hexView.string = data.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
                if contentType?.hasPrefix("image") ?? false {
                    removeTabViewItem(textItem)
                    addTabViewItem(imageItem)
                    imageView.image = NSImage(data : data)
                }
                else {
                    removeTabViewItem(imageItem)
                    addTabViewItem(textItem)
                    textView.string = NSString(data : data, encoding : NSUTF8StringEncoding) as? String
                }
            }
            else {
                removeTabViewItem(hexItem)
                removeTabViewItem(textItem)
                removeTabViewItem(imageItem)
            }
        }
        
    }
    
}

