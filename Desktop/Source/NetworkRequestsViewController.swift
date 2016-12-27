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
    let request : URLRequest
    let startTime : Date
    var endTime : Date?
    var response : URLResponse?
    var error : NSError?
    var data : NSMutableData?
    var cancelled : Bool = false
    
    init(request : URLRequest, startTime : Date) {
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
    
    deinit {
        tableView?.delegate = nil
        tableView?.dataSource = nil
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        // If we don't do this, the table won't properly account for the content inset.
        // This strikes me as an AppKit bug
        tableView?.tile()
    }
    
    func resultStringForRequest(_ request : NetworkRequestInfo) -> String {
        if let response = request.response {
            if let httpResponse = response as? HTTPURLResponse {
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
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        let request = requests[row]
        if tableColumn?.identifier == URLColumnIdentifier {
            cell.textField?.stringValue = request.request.url?.absoluteString ?? ""
        }
        else if tableColumn?.identifier == ResultColumnIdentifier {
            cell.textField?.stringValue = resultStringForRequest(request)
        }
        else if tableColumn?.identifier == TimestampColumnIdentifier {
            cell.textField?.stringValue = request.startTime.preciseDateString
        }
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selection = tableView?.selectedRow ?? -1
        if selection != -1 {
            emptyView?.isHidden = true
            infoView?.isHidden = false
            
            let info = requests[selection]
            infoView?.requestInfo = info
        }
        else {
            emptyView?.isHidden = false
            infoView?.isHidden = true
            
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
    
    func handleBeganMessage(_ message : DLSNetworkConnectionBeganMessage) {
        let info = NetworkRequestInfo(request: message.request, startTime: message.timestamp)
        requests.append(info)
        requestIndex[message.connectionID] = info
        reload()
    }
    
    func handleCompletedMessage(_ message : DLSNetworkConnectionCompletedMessage) {
        let info = requestIndex[message.connectionID]
        info?.response = message.response
        info?.endTime = message.timestamp
        reload()
    }
    
    func handleFailedMessage(_ message : DLSNetworkConnectionFailedMessage) {
        let info = requestIndex[message.connectionID]
        info?.error = message.error as NSError?
        reload()
    }
    
    func handleReceivedDataMessage(_ message : DLSNetworkConnectionReceivedDataMessage) {
        let info = requestIndex[message.connectionID]
        info?.data?.append(message.data)
        reload()
    }
    
    func handleCancelMessage(_ message : DLSNetworkConnectionCancelledMessage) {
        let info = requestIndex[message.connectionID]
        info?.endTime = message.timestamp
        info?.cancelled = true
        reload()
    }
}
