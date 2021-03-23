//
//  AnyComponent.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/23/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
