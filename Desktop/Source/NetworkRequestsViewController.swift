//
//  NetworkRequestsViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/2/15.
//
//

import Cocoa

private let URLColumnIdentifier = "URLColumnIdentifier"
private let ResultColumnIdentifier = "ResultColumnIdentifier"
private let TimestampColumnIdentifier = "TimestampColumnIdentifier"

class NetworkRequestInfo {
    let request : NSURLRequest
    let startTime : NSDate
    var endTime : NSDate?
    var response : NSURLResponse?
    var error : NSError?
    var data : NSMutableData?
    var cancelled : Bool = false
    
    init(request : NSURLRequest, startTime : NSDate) {
        self.request = request
        self.startTime = startTime
        self.data = NSMutableData()
    }
}

class NetworkRequestsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var requests : [NetworkRequestInfo] = []
    var requestIndex : [String : NetworkRequestInfo] = [:]
    @IBOutlet var tableView : NSTableView?
    @IBOutlet var emptyView : NSView?
    @IBOutlet var infoView : NetworkRequestInfoView?
    
    override func viewDidAppear() {
        super.viewDidAppear()
        // If we don't do this, the table won't properly account for the content inset.
        // This strikes me as an AppKit bug
        tableView?.tile()
    }
    
    func resultStringForRequest(request : NetworkRequestInfo) -> String {
        if let response = request.response {
            if let httpResponse = response as? NSHTTPURLResponse {
                return "\(httpResponse.statusCode) (\(httpResponse.statusCodeDescription))"
            }
            else {
                return "Loaded"
            }
        }
        else if request.cancelled {
            return "Cancelled"
        }
        else if let error = request.error {
            return "Error (\(error.code))"
        }
        else {
            return "Loading"
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return requests.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        let request = requests[row]
        if tableColumn?.identifier == URLColumnIdentifier {
            cell.textField?.stringValue = request.request.URL?.absoluteString ?? ""
        }
        else if tableColumn?.identifier == ResultColumnIdentifier {
            cell.textField?.stringValue = resultStringForRequest(request)
        }
        else if tableColumn?.identifier == TimestampColumnIdentifier {
            cell.textField?.stringValue = request.startTime.preciseDateString
        }
        return cell
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selection = tableView?.selectedRow ?? -1
        if selection != -1 {
            emptyView?.hidden = true
            infoView?.hidden = false
            
            let info = requests[selection]
            infoView?.requestInfo = info
        }
        else {
            emptyView?.hidden = false
            infoView?.hidden = true
            
            infoView?.requestInfo = nil
        }
    }
    
    func reload() {
        let atBottom : Bool
        if let clipView = tableView?.enclosingScrollView?.contentView {
            let documentRect = clipView.documentRect
            let bounds = clipView.bounds
            atBottom = bounds.maxY == documentRect.height
        }
        else {
            atBottom = false
        }
        
        tableView?.reloadData()
        if atBottom {
            tableView?.scrollToEndOfDocument(self)
        }
    }
    
    func handleBeganMessage(message : DLSNetworkConnectionBeganMessage) {
        let info = NetworkRequestInfo(request: message.request, startTime: message.timestamp)
        requests.append(info)
        requestIndex[message.connectionID] = info
        reload()
    }
    
    func handleCompletedMessage(message : DLSNetworkConnectionCompletedMessage) {
        let info = requestIndex[message.connectionID]
        info?.response = message.response
        info?.endTime = message.timestamp
        reload()
    }
    
    func handleFailedMessage(message : DLSNetworkConnectionFailedMessage) {
        let info = requestIndex[message.connectionID]
        info?.error = message.error
        reload()
    }
    
    func handleReceivedDataMessage(message : DLSNetworkConnectionReceivedDataMessage) {
        let info = requestIndex[message.connectionID]
        info?.data?.appendData(message.data)
        reload()
    }
    
    func handleCancelMessage(message : DLSNetworkConnectionCancelledMessage) {
        let info = requestIndex[message.connectionID]
        info?.endTime = message.timestamp
        info?.cancelled = true
        reload()
    }
}
