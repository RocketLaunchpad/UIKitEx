//
//  UIView.swift
//  Rocket Insights
//
//  Created by Ashley Streb on 6/26/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import Functional
import UIKit

// MARK: - Styling

public extension UIView {
    func applyStyle(_ style: Styling.View) {
        backgroundColor = .maybeColor(for: style.backgroundColor)
        if let opacity = style.opacity {
            alpha = opacity
        }
        layer.borderWidth = style.borderWidth ?? 0
        layer.borderColor = UIColor.maybeColor(for: style.borderColor)?.cgColor
        layer.cornerRadius = style.cornerRadius ?? 0
        addShadow(style.shadow)
    }

    func addShadow(_ shadow: Styling.Shadow?) {
        guard let shadow = shadow else {
            layer.shadowOffset = .zero
            layer.shadowRadius = 0
            return
        }

        guard shadow.opacity > 0 else { return }
        guard shadow.radius > 0 else { return }

        if !(self is TextControl) {
            layer.masksToBounds = false
        }

        layer.shadowOffset = shadow.offset
        layer.shadowRadius = shadow.radius
        layer.shadowOpacity = shadow.opacity
    }

    func removeShadow() {
        addShadow(nil)
    }

    func applyGradient(_ gradient: Styling.LinearGradient) {
        guard let gradientLayer = layer as? CAGradientLayer else {
            assertionFailure("Expected CAGradientLayer, got \(type(of: layer))")
            return
        }

        gradientLayer.colors = gradient.colors.map { UIColor.color(for: $0).cgColor }
        gradientLayer.startPoint = gradient.startPoint
        gradientLayer.endPoint = gradient.endPoint
    }

    func removeGradient() {
        guard let gradientLayer = layer as? CAGradientLayer else {
            assertionFailure("Expected CAGradientLayer, got \(type(of: layer))")
            return
        }

        gradientLayer.colors = []
    }
}

public extension UIView {
    var isShown: Bool {
        get { !isHidden }
        set { isHidden = !newValue }
    }
}

// MARK: - Separator

public extension UIView {
    var hasTopSeparator: Bool {
        get { containsSeparator(.top) }
        set { setSeparator(.top, enabled: newValue) }
    }

    var hasLeftSeparator: Bool {
        get { containsSeparator(.left) }
        set { setSeparator(.left, enabled: newValue) }
    }

    var hasBottomSeparator: Bool {
        get { containsSeparator(.bottom) }
        set { setSeparator(.bottom, enabled: newValue) }
    }

    var hasRightSeparator: Bool {
        get { containsSeparator(.right) }
        set { setSeparator(.right, enabled: newValue) }
    }

    enum SeparatorPlacement { case top, left, bottom, right }

    class SeparatorView: UIView {
        let placement: SeparatorPlacement
        
        required init(placement: SeparatorPlacement, color: UIColor = .separator) {
            self.placement = placement
            super.init(frame: .zero)
            
            backgroundColor = color
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override func didMoveToWindow() {
            super.didMoveToWindow()
            invalidateIntrinsicContentSize()
        }

        public override var intrinsicContentSize: CGSize {
            let scale: CGFloat = traitCollection.displayScale
            let thickness: CGFloat = 1.0 / scale
            switch placement {
            case .top, .bottom:
                return CGSize(width: UIView.noIntrinsicMetric, height: thickness)
            case .left, .right:
                return CGSize(width: thickness, height: UIView.noIntrinsicMetric)
            }
        }
    }

    private func findSeparator(_ placement: SeparatorPlacement) -> SeparatorView? {
        return subviews
            .first { subview in
                guard let separatorView = subview as? SeparatorView else { return false }
                return placement == separatorView.placement
            }
            .map { $0 as! SeparatorView } // swiftlint:disable:this force_cast
    }
    
    func addSeparator(_ placement: SeparatorPlacement) {
        guard !containsSeparator(placement) else { return }

        let color: UIColor = .color(for: .separator)
        let separatorView = SeparatorView(placement: placement, color: color)
        addSubview(separatorView)

        switch separatorView.placement {
        case .top:
            separatorView.alignTopAndSides(to: self).activate()

        case .left:
            separatorView.alignLeftAndSides(to: self).activate()

        case .bottom:
            separatorView.alignBottomAndSides(to: self).activate()

        case .right:
            separatorView.alignRightAndSides(to: self).activate()
        }
    }

    func removeAllSeparators() {
        removeSeparator(.top)
        removeSeparator(.bottom)
        removeSeparator(.left)
        removeSeparator(.right)
    }

    private func containsSeparator(_ placement: SeparatorPlacement) -> Bool {
        return findSeparator(placement) != nil
    }
    
    private func removeSeparator(_ placement: SeparatorPlacement) {
        findSeparator(placement)?.removeFromSuperview()
    }

    private func setSeparator(_ placement: SeparatorPlacement, enabled: Bool) {
        placement |> (enabled ? addSeparator : removeSeparator)
    }
}

// MARK: - Chevron

public extension UIView {
    static func chevron() -> UIView {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.right")
        view.tintColor = .lightGray
        view.contentMode = .center
        return view
    }
}

// MARK: - Common Utility Methods

public extension UIView {
    func scrollToVisible(makeTopVisible: Bool = true, animated: Bool = true) {
        guard let scrollView: UIScrollView = enclosingSuperview() else { return }
        var rect = convert(bounds, to: scrollView)
        if makeTopVisible {
            let maxVisibleHeight = scrollView.bounds.height
                - scrollView.safeAreaInsets.top
                - scrollView.safeAreaInsets.bottom
                - scrollView.contentInset.bottom
            rect.size.height = min(rect.size.height, maxVisibleHeight)
        }
        scrollView.scrollRectToVisible(rect, animated: animated)
    }

    func applyToSubtree(_ f: (UIView) -> Void) {
        for view in subviews {
            f(view)
            view.applyToSubtree(f)
        }
    }

    func recursivelyFindSubview(_ condition: (UIView) -> Bool) -> UIView? {
        if condition(self) {
            return self
        }

        for view in subviews {
            if let found = view.recursivelyFindSubview(condition) {
                return found
            }
        }

        return nil
    }

    func recursivelyFindSubview<T: UIView>() -> T? {
        recursivelyFindSubview { $0 is T } as? T
    }

    func enclosingSuperview<T>() -> T? {
        return sequence(first: self, next: { $0.superview }).first { $0 is T }.flatMap { $0 as? T }
    }

    static func resourceImage(named name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle(for: self), compatibleWith: nil)
    }

    func moveUnderSuperview() {
        guard let superview = superview else { return }
        layoutIfNeeded()
        let shadowDistance = layer.shadowRadius + abs(layer.shadowOffset.height)
        transform = .init(translationX: 0, y: superview.bounds.height - frame.minY + shadowDistance)
    }

    func restoreLocation() {
        transform = .identity
    }
}

// MARK: - First Responder

public extension UIView {
    func currentFirstResponder() -> UIView? {
        if isFirstResponder {
            return self
        }
        
        for view in subviews {
            if let view = view.currentFirstResponder() {
                return view
            }
        }
        
        return nil
    }

    func postDidBecomeFirstResponderNotification() {
        NotificationCenter.default.post(name: .didBecomeFirstResponder, object: self)
    }

    /// Resigns the first responder first to avoid auto scrolling.
    /// This helps avoid scrolling to the wrong place when a text form item
    /// has additional elements.
    static func changeFirstResponder(from: UIView?, to: UIView?) {
        from?.resignFirstResponder()
        to?.becomeFirstResponder()
    }
}

public extension NSNotification.Name {
    static let didBecomeFirstResponder = NSNotification.Name("didBecomeFirstResponderName")
}

#endif
