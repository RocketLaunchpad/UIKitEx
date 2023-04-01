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
