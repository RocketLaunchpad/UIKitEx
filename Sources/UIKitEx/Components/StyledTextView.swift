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

open class StyledTextView<F: FontStyling>: UITextView, InputView, AnyUIKitComponent {
    fileprivate var placeholderLabel: UILabel!

    public var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    @objc fileprivate func textDidChange() {
        placeholderLabel.isShown = text.isEmpty
        onTextDidChange()
    }

    public func onTextDidChange() {}

    public override var text: String! {
        didSet {
            textDidChange()
        }
    }

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private var isConfigured = false

    public func configure() {
        guard !isConfigured else { return }
        defer { isConfigured = true }

        placeholderLabel = UILabel()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        placeholderLabel.alignTopAndSides(
            to: self,
            insetBy: UIEdgeInsets(
                top: textContainerInset.top,
                left: textContainerInset.left + textContainer.lineFragmentPadding,
                bottom: 0,
                right: textContainerInset.right + textContainer.lineFragmentPadding
            )
        )
        .activate()

        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }

    // MARK: InputView

    public weak var nextInputView: InputView?
    public weak var previousInputView: InputView?

    // Styling

    public typealias Style = Styling.TextField<F>
    public var currentStyle: Style?
    public var currentTraits: Styling.Traits?

    open class func style(_ traits: Styling.Traits) -> Style? { nil }

    open func applyStyle(_ style: Style) {
        backgroundColor = .color(for: style.backgroundColor)
        font = F.font(for: style.font)
        textColor = .maybeColor(for: style.textColor)

        placeholderLabel.backgroundColor = .clear
        placeholderLabel.font = font
        placeholderLabel.textColor = .maybeColor(for: style.placeholderColor)

        // Adding a real shadow would require a view under the text view (the text view
        // clips its bounds because otherwise the text that doesn't fit the frame is still displayed
        // beyond the text view bounds). Having to deal with this additional view is error prone.
        // The code below provides some styling while keeping the code simple.
        if style.boxShadow != nil {
            layer.borderWidth = currentTraits?.separatorThickness ?? 1
            layer.borderColor = UIColor.color(for: .separator).cgColor
            layer.cornerRadius = 4
        }
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

    // UIKit overrides

    public override func becomeFirstResponder() -> Bool {
        guard super.becomeFirstResponder() else { return false }
        onBecomeFirstResponder()

        postDidBecomeFirstResponderNotification()
        return true
    }

    open func onBecomeFirstResponder() {
    }
}

#endif
