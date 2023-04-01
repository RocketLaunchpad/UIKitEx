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

public protocol ConfigurableView: UIView {
    associatedtype Environment
    associatedtype ContentType
    func configure(_ value: ContentType, isSelected: Bool, env: Environment, traits: Styling.Traits)
    static func estimatedSize(traits: Styling.Traits) -> CGSize
    static var logSizeDiff: Bool { get }
}

public extension ConfigurableView {
    static func estimatedSize(traits: Styling.Traits) -> CGSize {
        .zero
    }

    static var logSizeDiff: Bool {
        true
    }
}

open class ItemViewCell<V: ConfigurableView>: UICollectionViewCell {
    public var itemView = V()

    override init(frame: CGRect) {
        super.init(frame: frame)
        itemView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemView)
        itemView.align(to: contentView).activate()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(_ value: V.ContentType, isSelected: Bool, env: V.Environment, traits: Styling.Traits) {
        itemView.configure(value, isSelected: isSelected, env: env, traits: traits)
    }

    public override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        systemLayoutSizeFitting(targetSize)
    }

    public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        itemView.systemLayoutSizeFitting(targetSize)
    }
}

#endif
