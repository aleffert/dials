//
//  RequestContentTabController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/13/15.
//
//

import Cocoa

struct RequestDataExtractor {
    let metadataExtractor : (NetworkRequestInfo) -> [(String, NSAttributedString)]
    let contentTypeExtractor : (NetworkRequestInfo) -> String?
    let dataExtractor : (NetworkRequestInfo) -> Data?
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
        hexView.enclosingScrollView?.horizontalScrollElasticity = .none
        textView.enclosingScrollView?.horizontalScrollElasticity = .none
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
    
    fileprivate static func requestContentTypeExtractor(_ info: NetworkRequestInfo) -> String? {
        let map = info.request.allHTTPHeaderFields
        return map?["Content-Type"]
    }
    
    fileprivate static func requestDataExtractor(_ info : NetworkRequestInfo) -> Data? {
        return info.request.httpBody
    }
    
    static let requestDataExtractor : RequestDataExtractor = RequestDataExtractor(
        metadataExtractor: NetworkRequestStatusView.requestDataExtractor,
        contentTypeExtractor: RequestContentTabController.requestContentTypeExtractor,
        dataExtractor: RequestContentTabController.requestDataExtractor
    )
    
    fileprivate static func responseContentTypeExtractor(_ info: NetworkRequestInfo) -> String? {
        let map = (info.response as? HTTPURLResponse)?.allHeaderFields as? [String:String]
        return map?["Content-Type"]
    }
    
    fileprivate static func responseDataExtractor(_ info : NetworkRequestInfo) -> Data? {
        return info.data as Data?
    }
    
    static let responseDataExtractor : RequestDataExtractor = RequestDataExtractor(
        metadataExtractor: NetworkRequestStatusView.responseDataExtractor,
        contentTypeExtractor: RequestContentTabController.responseContentTypeExtractor,
        dataExtractor: RequestContentTabController.responseDataExtractor
    )
    
    fileprivate func addTabViewItem(_ item : NSTabViewItem) {
        if !(tabView.tabViewItems as NSArray).contains(item) {
            self.tabView.addTabViewItem(item)
        }
    }
    
    fileprivate func removeTabViewItem(_ item : NSTabViewItem) {
        if (tabView.tabViewItems as NSArray).contains(item) {
            self.tabView.removeTabViewItem(item)
        }
    }
    
    var requestInfo : NetworkRequestInfo? {
        didSet {
            statusView.requestInfo = requestInfo
            let contentType = requestInfo.flatMap { dataExtractor.contentTypeExtractor($0) }
            
            if let data = requestInfo.flatMap({ dataExtractor.dataExtractor($0) }) {
                addTabViewItem(hexItem)
                hexView.string = data.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
                if contentType?.hasPrefix("image") ?? false {
                    removeTabViewItem(textItem)
                    addTabViewItem(imageItem)
                    imageView.image = NSImage(data : data)
                }
                else {
                    removeTabViewItem(imageItem)
                    addTabViewItem(textItem)
                    textView.string = NSString(data : data, encoding : String.Encoding.utf8.rawValue) as String?
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

