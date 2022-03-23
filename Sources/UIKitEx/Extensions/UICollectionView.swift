//
//  UICollectionView.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 6/19/17.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class CollectionViewArrayDataSource<T, Cell: UICollectionViewCell>: NSObject, UICollectionViewDataSource {
    var items: [T] = []
    let configureCell: (Cell, T, UICollectionView) -> Void

    public init(_ items: [T] = [], configureCell: @escaping (Cell, T, UICollectionView) -> Void) {
        self.items = items
        self.configureCell = configureCell
        super.init()
        update(items)
    }

    public func update(_ items: [T]) {
        self.items = items
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueCell(for: indexPath)
        let index = indexPath.item
        configureCell(cell, items[index], collectionView)
        return cell
    }
}

public extension UICollectionReusableView {
    class var reuseID: String {
        return String(describing: self)
    }
}

public extension UICollectionView {
    func registerClass(for cellClass: UICollectionViewCell.Type) {
        register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseID)
    }

    func registerClass(for reusableViewClass: UICollectionReusableView.Type, kind: String) {
        register(reusableViewClass.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: reusableViewClass.reuseID)
    }

    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Cell must of class \(T.reuseID)")
        }
        
        return cell
    }
    
    func dequeueCell(for indexPath: IndexPath, cellClass: UICollectionViewCell.Type) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: cellClass.reuseID, for: indexPath)
    }
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Supplementary View must be of type \(T.reuseID)")
        }
        
        return view
    }
}

#endif
