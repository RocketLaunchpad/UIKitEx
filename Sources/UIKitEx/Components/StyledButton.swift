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
