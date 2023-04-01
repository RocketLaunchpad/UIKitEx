//
// Copyright (c) 2023 DEPT Digital Products, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#if canImport(UIKit)

import UIKit

// Box types seemed convenient for diffable data sources, but they don't work in general because
// if an element at a certain index changes, a diffable data source that treats the index
// as the identifier is unable to detect the change.

// Box types can be used only in the cases where the data is either never changed or is only appended
// so that the existing indexes always describe the same elements.

/// Values for diffable data sources
public struct Box<T>: Hashable {
    public let index: Int
    public let value: T
    public let isSelected: Bool

    public init(index: Int, value: T, isSelected: Bool) {
        self.index = index
        self.value = value
        self.isSelected = isSelected
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        hasher.combine(isSelected)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.index == rhs.index &&
        lhs.isSelected == rhs.isSelected
    }
}

public struct Box2<T>: Hashable {
    public let index1: Int
    public let index2: Int
    public let value: T

    public init(index1: Int, index2: Int, value: T) {
        self.index1 = index1
        self.index2 = index2
        self.value = value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(index1)
        hasher.combine(index2)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        (lhs.index1 == rhs.index1) &&
        (lhs.index2 == rhs.index2)
    }
}

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
