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

public extension UILabel {
    func apply<F: FontStyling>(_ styleArg: Styling.Text<F>) {
        var style = styleArg

        removeTextShadow()
        if numberOfLines == 1 {
            style.lineSpacing = nil
        }
        attributedText = text?.styled(as: style)
        if let shadow = style.shadow {
            addTextShadow(shadow)
        }
    }
}

open class AnyStyledLabel<F: FontStyling>: UILabel, AnyUIKitComponent {
    public typealias Style = Styling.Text<F>
    public var currentStyle: Style?
    public var currentTraits: Styling.Traits?

    open class func style(_ traits: Styling.Traits) -> Style? { nil }

    open class func singleLineHeight(_ traits: Styling.Traits) -> CGFloat? {
        guard let style = style(traits) else { return nil }
        let font: UIFont = F.font(for: style.font)
        return font.lineHeight
    }

    open func updateLayout(forTraits traits: Styling.Traits, style: Style) {
    }

    open func applyStyle(_ style: Style) {
        apply(style)
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

open class StyledLabel<F: FontStyling>: AnyStyledLabel<F> {
    private var savedText: String? = ""

    public var styleFunc: Styling.TextFunc<F>?

    public func applyStyleFunc() {
        let traits: Styling.Traits = .traits(traitCollection)
        guard let styleFunc = styleFunc else { return update() }
        apply(styleFunc(traits))
    }

    public override var text: String? {
        get {
            return savedText
        }
        set {
            savedText = newValue
            applyStyleFunc()
        }
    }

    public override var textColor: UIColor! {
        didSet {
            applyStyleFunc()
        }
    }
}

open class MixedStyleLabel<F: FontStyling>: AnyStyledLabel<F> {
    private var isStyling = false

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        if singleLineLayout {
            lineBreakMode = .byTruncatingTail
            numberOfLines = 1
            adjustsFontSizeToFitWidth = true
        }
        else {
            numberOfLines = 0
        }
    }

    public var singleLineLayout = true

    public var styledText: (_ traits: Styling.Traits) -> NSAttributedString = { _ in
        NSAttributedString()
        } {
        didSet {
            guard let traits = currentTraits else { return }
            isStyling = true
            attributedText = styledText(traits)
            isStyling = false
        }
    }

    // not used but should be here to get to updateLayout()
    public override class func style(_ traits: Styling.Traits) -> Style {
        Style(font: F.default(traits))
    }

    public override func applyStyle(_ style: Style) {
    }

    public override func updateLayout(forTraits traits: Styling.Traits, style: Style) {
        // use the layout callback to update the style because it has the most complete info
        isStyling = true
        attributedText = styledText(traits)
        isStyling = false
    }

    public override var text: String? {
        didSet {
            assert(
                text == attributedText?.string,
                "Use the styledText property to change the text"
            )
        }
    }

    public override var attributedText: NSAttributedString? {
        didSet {
            assert(isStyling, "Use the styledText property to change the text")
        }
    }
}

#endif
