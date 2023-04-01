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
    struct TextField<F: FontStyling> {
        public var font: F
        public var textColor: Color?
        public var placeholderColor: Color?
        public var backgroundColor: Color = .white
        public var readonlyBackgroundColor: Color?
        public var textInsets: EdgeInsets
        public var caretInsets: EdgeInsets?
        public var boxShadow: Shadow?

        public init(font: F, textColor: Styling.Color? = nil, placeholderColor: Styling.Color? = nil, backgroundColor: Styling.Color = .white, readonlyBackgroundColor: Styling.Color? = nil, textInsets: Styling.EdgeInsets, caretInsets: Styling.EdgeInsets? = nil, boxShadow: Styling.Shadow? = nil) {
            self.font = font
            self.textColor = textColor
            self.placeholderColor = placeholderColor
            self.backgroundColor = backgroundColor
            self.readonlyBackgroundColor = readonlyBackgroundColor
            self.textInsets = textInsets
            self.caretInsets = caretInsets
            self.boxShadow = boxShadow
        }
    }
}

open class StyledTextField<F: FontStyling>: UITextField, InputView, AnyUIKitComponent {
    public var isReadOnly = false {
        didSet {
            isUserInteractionEnabled = !isReadOnly
            update()
        }
    }

    // Styling

    public typealias Style = Styling.TextField<F>
    public var currentStyle: Style?
    public var currentTraits: Styling.Traits?

    open class func style(_ traits: Styling.Traits) -> Style? { nil }

    open func applyStyle(_ style: Style) {
        removeShadow()

        let styleBackgroundColor = isReadOnly ? style.readonlyBackgroundColor : style.backgroundColor
        borderStyle = .none
        backgroundColor = .maybeColor(for: styleBackgroundColor)
        font = F.font(for: style.font)
        tintColor = .maybeColor(for: style.textColor)
        isOpaque = (backgroundColor != nil)
        addShadow(style.boxShadow)
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

    // InputView

    public weak var nextInputView: InputView?
    public weak var previousInputView: InputView?

    // UIKit overrides

    public override var keyboardType: UIKeyboardType {
        didSet {
            if keyboardType != oldValue {
                reloadInputViews()
            }
        }
    }

    public override func becomeFirstResponder() -> Bool {
        guard !isReadOnly else { return false }
        guard super.becomeFirstResponder() else { return false }
        postDidBecomeFirstResponderNotification()
        onBecomeFirstResponder()
        return true
    }

    // Cannot override becomeFirstResponder() -- that crashes Xcode previews
    open func onBecomeFirstResponder() {
    }

    public override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        guard let style = currentStyle else { return rect }

        if let insets = style.caretInsets {
            rect.origin.y += insets.top
            rect.size.height -= (insets.top + insets.bottom)
        }
        rect.size.width = 1
        return rect
    }

    public override func drawPlaceholder(in rect: CGRect) {
        guard let placeholder = placeholder else { return }
        guard let style = currentStyle else { return }

        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[.font] = F.font(for: style.font)
        attributes[.foregroundColor] = UIColor.maybeColor(for: style.placeholderColor)

        placeholder.draw(at: rect.origin, withAttributes: attributes)
    }

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.textRect(forBounds: bounds)
        guard let style = currentStyle else { return rect }

        let insets = style.textInsets
        rect.origin.x += insets.left
        rect.origin.y += insets.top
        rect.size.width -= (insets.left + insets.right)
        rect.size.height -= (insets.top + insets.bottom)
        return rect
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    public override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        guard let style = currentStyle else { return size }

        let insets = style.textInsets
        size.width += (insets.left + insets.right)
        size.height += (insets.top + insets.bottom)
        return size
    }
}

#endif
