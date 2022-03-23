//
//  UITableView.swift
//  Rocket Insights
//
//  Created by Chris Whinfrey on 6/14/17.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class TableViewArrayDataSource<T, Cell: UITableViewCell>: NSObject, UITableViewDataSource {
    var items: [T] = []
    let configureCell: (Cell, T, UITableView) -> Void

    public init(_ items: [T] = [], configureCell: @escaping (Cell, T, UITableView) -> Void) {
        self.items = items
        self.configureCell = configureCell
        super.init()
        update(items)
    }

    public func value(at indexPath: IndexPath) -> T? {
        guard indexPath.row < items.count else { return nil }
        return items[indexPath.row]
    }

    public func update(_ items: [T]) {
        self.items = items
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueCell(for: indexPath)
        let index = indexPath.item
        configureCell(cell, items[index], tableView)
        return cell
    }
}

public extension UITableViewCell {
    class var reuseID: String {
        return String(describing: self)
    }
    
    var indexPath: IndexPath? {
        guard let tableView: UITableView = enclosingSuperview() else { return nil }
        return tableView.indexPath(for: self)
    }
}

public extension UITableViewHeaderFooterView {
    class var reuseID: String {
        return String(describing: self)
    }
}

public extension UITableView {
    func registerNib(for cellClass: UITableViewCell.Type) {
        register(UINib(nibName: cellClass.reuseID, bundle: nil), forCellReuseIdentifier: cellClass.reuseID)
    }
    
    func registerNib(forView viewClass: UITableViewHeaderFooterView.Type) {
        register(UINib(nibName: viewClass.reuseID, bundle: nil), forHeaderFooterViewReuseIdentifier: viewClass.reuseID)
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("reuse ID \(T.reuseID) must be registered for type \(T.self)")
        }
        
        return cell
    }
    
    func dequeueView<T: UITableViewHeaderFooterView>(forSection section: Int) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseID) as? T else {
            fatalError("reuse ID \(T.reuseID) must be registered for type \(T.self)")
        }
        
        return view
    }
    
    func deselectSelectedRow() {
        if let selectedIndexPath = indexPathForSelectedRow {
            deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        guard let dataSource = dataSource else {
            assertionFailure()
            return false
        }

        let sectionCount = dataSource.numberOfSections?(in: self) ?? 1
        guard indexPath.section < sectionCount else {
            assertionFailure("Expected \(sectionCount) section(s), so section \(indexPath.section) is out of range")
            return false
        }
        
        let count = dataSource.tableView(self, numberOfRowsInSection: indexPath.section)
        guard indexPath.row < count else {
            assertionFailure("Expected \(count) row(s) in section, so row \(indexPath.row) is out out of range")
            return false
        }
        
        return true
    }
}

#endif
