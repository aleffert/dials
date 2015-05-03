//
//  NetworkRequestsViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 5/2/15.
//
//

import Cocoa

private let URLColumnIdentifier = "URLColumnIdentifier"
private let ResultCodeColumnIdentifier = "ResultCodeColumnIdentifier"
private let TimestampColumnIdentifier = "TimestampColumnIdentifier"

class NetworkRequestInfo {
    let request : NSURLRequest
    let timestamp : NSDate
    var response : NSURLResponse?
    
    init(request : NSURLRequest, timestamp : NSDate, response : NSURLResponse?) {
        self.request = request
        self.timestamp = timestamp
        self.response = response
    }
}

class NetworkRequestsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var requests : [NetworkRequestInfo] = []
    var requestIndex : [String : NetworkRequestInfo] = [:]
    @IBOutlet var tableView : NSTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        else if tableColumn?.identifier == ResultCodeColumnIdentifier {
            cell.textField?.stringValue = "Loading"
            
        }
        else if tableColumn?.identifier == TimestampColumnIdentifier {
            cell.textField?.stringValue = NSDateFormatter.localizedStringFromDate(request.timestamp, dateStyle: .ShortStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
        }
        return cell
    }
    
    func handleBeganMessage(message : DLSNetworkConnectionBeganMessage) {
        let info = NetworkRequestInfo(request: message.request, timestamp: message.timestamp, response: nil)
        requests.append(info)
        requestIndex[message.connectionID] = info
        tableView?.reloadData()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        // If we don't do this, the table won't properly account for the content inset
        // this strikes me as an AppKit bug
        tableView?.tile()
    }
    
    func handleCompletedMessage(message : DLSNetworkConnectionCompletedMessage) {
        
    }
    
    func handleFailedMessage(message : DLSNetworkConnectionFailedMessage) {
        
    }
    
    func handleReceivedDataMessage(message : DLSNetworkConnectionReceivedDataMessage) {
        
    }
}
