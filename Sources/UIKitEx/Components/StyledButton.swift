//
//  StyledButton.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/22/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public extension Styling {
    struct Button<F: FontStyling> {
        public var view: View
        public var contentEdgeInsets: EdgeInsets?
        public var imageEdgeInsets: EdgeInsets?
        public var titleFont: F
        public var titleColor: Color
        public var textShadow: Shadow?

        public init(view: Styling.View, contentEdgeInsets: Styling.EdgeInsets? = nil, imageEdgeInsets: Styling.EdgeInsets? = nil, titleFont: F, titleColor: Styling.Color, textShadow: Styling.Shadow? = nil) {
            self.view = view
            self.contentEdgeInsets = contentEdgeInsets
            self.imageEdgeInsets = imageEdgeInsets
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.textShadow = textShadow
        }
    }

    static var buttonDisabledStateAlpha: CGFloat = 1
}

open class StyledButton<F: FontStyling>: UIButton, AnyUIKitComponent  {
    public override var intrinsicContentSize: CGSize {
        let contentSize = super.intrinsicContentSize
        guard let style = currentStyle else { return contentSize }
        let height = style.view.height ?? contentSize.height
        return CGSize(width: contentSize.width, height: height)
    }

    // Styling

    public override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : Styling.buttonDisabledStateAlpha
        }
    }

    public typealias Style = Styling.Button<F>
    public var currentStyle: Style?
    public var currentTraits: Styling.Traits?

    open class func style(_ traits: Styling.Traits) -> Style? { nil }

    open func applyStyle(_ style: Style) {
        applyStyle(style.view)

        titleLabel?.removeTextShadow()

        if let textShadow = style.textShadow {
            titleLabel?.addTextShadow(textShadow)
        }

        if let contentEdgeInsets = style.contentEdgeInsets {
            self.contentEdgeInsets = .edgeInsets(for: contentEdgeInsets)
        }
        if let imageEdgeInsets = style.imageEdgeInsets {
            self.imageEdgeInsets = .edgeInsets(for: imageEdgeInsets)
        }

        titleLabel?.font = F.font(for: style.titleFont)
        setTitleColor(.color(for: style.titleColor), for: .normal)
    }

    open func updateLayout(forTraits traits: Styling.Traits, style: Style) {
        invalidateIntrinsicContentSize()
    }

    // Callbacks for styling

    public func overrideCallbacksForStyling() {}

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        onDidMoveToSuperview()
    }

    public override func traitCollectionDidChange(_ previous: UITraitCollection?) {
        super.traitCollectionDidChange(previous)
        onTraitCollectionDidChange(previous)
    }
}

#endif
