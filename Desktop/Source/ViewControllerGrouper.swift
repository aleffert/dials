//
//  ViewControllerGrouper.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/9/14.
//
//

import Cocoa

let ViewControllerGrouperCellIdentifier = "ViewControllerGrouperCellIdentifier"

private enum Row {
    case Singleton(NamedGroup<NSViewController>)
    case Heading(NamedGroup<NSViewController>)
    case Controller(NSViewController)
}

class NamedGroup<A> {
    var items : [A] = []
    let name : String
    let label : String
    
    init(name : String, label : String) {
        self.name = name
        self.label = label;
    }
}

typealias ViewControllerGroup = NamedGroup<NSViewController>

protocol ViewControllerGrouperDelegate : class {
    func controllerGroupSelectedController(controller : NSViewController)
}

class ViewControllerGrouper: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    weak var delegate : ViewControllerGrouperDelegate?
    private var groups : [ViewControllerGroup] = []
    private var rows : [Row] = []
    
    private func buildRowList() -> [Row] {
        var result : [Row] = []
        for group in groups {
            if group.items.count == 1 {
                 result.append(Row.Singleton(group))
            }
            else {
                result.append(Row.Heading(group))
                result.extend(group.items.map{ Row.Controller($0) })
            }
        }
        return result
    }

    func addViewController(controller: NSViewController, plugin: Plugin) {
        var found = false
        for group in groups {
            if group.name == plugin.identifier {
                group.items.append(controller)
                if plugin.shouldSortChildren {
                    group.items.sort({ (left, right) -> Bool in
                        return left.title < right.title
                    })
                }
                found = true
                break
            }
        }
        
        if !found {
            let group = NamedGroup<NSViewController>(name: plugin.identifier, label: plugin.label)
            group.items = [controller]
            groups.append(group)
        }
        groups.sort { (left, right) -> Bool in
            return left.label < right.label
        }
        rows = buildRowList()
    }
    
    func removeViewController(controller: NSViewController, plugin: Plugin) {
        for group in groups {
            if group.name == plugin.identifier {
                group.items = group.items.filter { return $0 != controller }
            }
        }
        groups = groups.filter({ return $0.items.count > 0 })
        rows = buildRowList()
    }
    
    var hasMultipleItems : Bool {
        return rows.count > 0
    }
    
    func controllerForRow(row : Int) -> NSViewController? {
        let item = rows[row]
        switch item {
        case .Heading(_):
            return nil
        case .Singleton(let group):
            return group.items[0]
        case .Controller(let controller):
            return controller
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return rows.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(ViewControllerGrouperCellIdentifier, owner: nil) as! NSTableCellView
        let item = rows[row]
        switch item {
        case .Heading(let group):
            cell.textField?.stringValue = group.label
        case .Singleton(let group):
            cell.textField?.stringValue = group.label
            cell.textField?.font = NSFont.boldSystemFontOfSize(11)
        case .Controller(let controller):
            cell.textField?.stringValue = controller.title ?? "Item"
            cell.textField?.font = NSFont.systemFontOfSize(12)
        }
        return cell
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let item = rows[row]
        switch item {
        case .Singleton(_): fallthrough
        case .Heading(_):
            if row == 0 {
                return 20
            }
            else {
                return 24
            }
        case .Controller(_):
            return 20
        }
    }
    
    func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
        let item = rows[row]
        switch item {
        case .Singleton(_): return false
        case .Heading(_): return true
        case .Controller(_): return false
        }
    }
    
    func tableView(tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet {
        let resultSet = NSMutableIndexSet()
        var index = proposedSelectionIndexes.firstIndex
        while index != NSNotFound {
            let groupRow = self.tableView(tableView, isGroupRow: index as Int)
            if !groupRow {
                resultSet.addIndex(index)
            }
            index = proposedSelectionIndexes.indexGreaterThanIndex(index)
        }
        return resultSet
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let tableView = notification.object as! NSTableView
        let selection = tableView.selectedRow
        if selection != -1 {
            if let controller = controllerForRow(selection) {
                delegate?.controllerGroupSelectedController(controller)
            }
        }
    }
    
    func controllersForRowIndexes(indexes : NSIndexSet) -> [NSViewController] {
        var result : [NSViewController] = []
        for i in 0 ..< rows.count {
            let row = rows[i]
            if indexes.containsIndex(i) {
                switch row {
                case let .Singleton(group):
                    result.append(group.items[0])
                case let .Heading(_):
                    continue
                case let .Controller(c):
                    result.append(c)
                }
            }
        }
        return result
    }
    
    func rowIndexesForControllers(controllers : [NSViewController]) -> NSIndexSet {
        let result = NSMutableIndexSet()
        for i in 0 ..< rows.count {
            if let c = controllerForRow(i) {
                if (find(controllers, c) != nil) {
                    result.addIndex(i)
                }
            }
        }
        return result
    }
    
    private func adjacentTabIndex(existingIndex : Int, range : [Int]) -> Int {
        var index = existingIndex
        for i in range {
            let proposed = (i + existingIndex + rows.count) % rows.count
            let item = rows[proposed]
            switch item {
            case .Singleton(_): return proposed
            case .Controller(_): return proposed
            case .Heading(_): continue
            }
        }
        return existingIndex
    }
    
    func nextTabIndex(existingIndex : Int) -> Int {
        return adjacentTabIndex(existingIndex, range : Array(1 ... rows.count))
    }
    
    func previousTabIndex(existingIndex : Int) -> Int {
        return adjacentTabIndex(existingIndex, range : reverse(0 ..< rows.count))
    }

}
