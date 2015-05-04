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
    let timestamp : NSDate
    var response : NSURLResponse?
    var error : NSError?
    var data : NSMutableData?
    
    init(request : NSURLRequest, timestamp : NSDate, response : NSURLResponse? = nil, error : NSError? = nil) {
        self.request = request
        self.timestamp = timestamp
        self.response = response
        self.error = error
        self.data = NSMutableData()
    }
}

class NetworkRequestsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var requests : [NetworkRequestInfo] = []
    var requestIndex : [String : NetworkRequestInfo] = [:]
    @IBOutlet var tableView : NSTableView?
    
    lazy var formatter : NSDateFormatter = {
        let f = NSDateFormatter()
        f.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        return f
    }()
    
    override func viewDidAppear() {
        super.viewDidAppear()
        // If we don't do this, the table won't properly account for the content inset.
        // This strikes me as an AppKit bug
        tableView?.tile()
    }
    
    func resultStringForRequest(request : NetworkRequestInfo) -> String {
        if let response = request.response {
            if let httpResponse = request.response as? NSHTTPURLResponse {
                return "\(httpResponse.statusCode) (\(httpResponse.statusCodeDescription))"
            }
            else {
                return "Loaded"
            }
        }
        else {
            if let error = request.error {
                return "Error (\(error.code))"
            }
            else {
                return "Loading"
            }
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
            cell.textField?.stringValue = formatter.stringFromDate(request.timestamp)
        }
        return cell
    }
    
    func handleBeganMessage(message : DLSNetworkConnectionBeganMessage) {
        let info = NetworkRequestInfo(request: message.request, timestamp: message.timestamp, response: nil)
        requests.append(info)
        requestIndex[message.connectionID] = info
        tableView?.reloadData()
    }
    
    func handleCompletedMessage(message : DLSNetworkConnectionCompletedMessage) {
        let info = requestIndex[message.connectionID]
        info?.response = message.response
        tableView?.reloadData()
    }
    
    func handleFailedMessage(message : DLSNetworkConnectionFailedMessage) {
        let info = requestIndex[message.connectionID]
        info?.error = message.error
        tableView?.reloadData()
    }
    
    func handleReceivedDataMessage(message : DLSNetworkConnectionReceivedDataMessage) {
        let info = requestIndex[message.connectionID]
        info?.data?.appendData(message.data)
        tableView?.reloadData()
    }
}
