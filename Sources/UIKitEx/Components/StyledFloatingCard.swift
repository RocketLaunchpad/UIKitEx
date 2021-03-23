//
//  StyledFloatingCard.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/23/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension Styling {
    struct FloatingCard {
        public var shadow: Shadow
        public var cornerRadius: CGFloat
        public var roundBottom = true

        public init(shadow: Styling.Shadow, cornerRadius: CGFloat, roundBottom: Bool = true) {
            self.shadow = shadow
            self.cornerRadius = cornerRadius
            self.roundBottom = roundBottom
        }

        public static var `default`: (_ traits: Styling.Traits) -> Self = { _ in
            .init(
                shadow: .init(offset: .init(width: 0, height: 3), radius: 3, opacity: 0.1),
                cornerRadius: 7
            )
        }
    }
}

public typealias FloatingCardStyle = Styling.FloatingCard

// Knowing the type of the content wrapped in a card helps working with the content.
open class FloatingCard<V: UIView>: UIView, ContainerView {
    public typealias Style = FloatingCardStyle
    public typealias StyleFunc = (_ traits: Styling.Traits) -> Style
    public typealias ContentView = V

    public private(set) var contentView: V
    private var styleFunc: StyleFunc

    private func applyStyle(_ style: Style) {
        contentView.layer.cornerRadius = style.cornerRadius
        if !style.roundBottom {
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        contentView.clipsToBounds = true

        layer.masksToBounds = false
        layer.cornerRadius = style.cornerRadius
        if !style.roundBottom {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        addShadow(style.shadow)
    }

    private func updateStyle() {
        applyStyle(styleFunc(.traits(traitCollection)))
    }

    public init(_ contentView: V, styleFunc: @escaping StyleFunc) {
        self.contentView = contentView
        self.styleFunc = styleFunc

        super.init(frame: .zero)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.align(to: self).activate()
    }

    public convenience override init(frame: CGRect) {
        self.init(V(), styleFunc: Style.default)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        contentView.systemLayoutSizeFitting(targetSize)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateStyle()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateStyle()
    }
}

#endif
