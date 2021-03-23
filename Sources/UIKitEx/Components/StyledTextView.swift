//
//  StyledTextView.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/23/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
