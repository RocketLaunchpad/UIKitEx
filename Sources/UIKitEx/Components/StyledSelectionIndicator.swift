//
//  StyledSelectionIndicator.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/22/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public extension Styling {
    struct SelectionIndicator {
        public var thickness: CGFloat
        public var color: Color

        public init(thickness: CGFloat, color: Styling.Color) {
            self.thickness = thickness
            self.color = color
        }
    }
}

open class StyledSelectionIndicator: UIView, AnyUIKitComponent {
    public enum Mode {
        case horizontalBottom, horizontalTop, vertical
    }

    public var mode: Mode = .horizontalBottom

    private var layout = Layout()
    weak var selectedView: UIView?

    public override func didMoveToWindow() {
        super.didMoveToWindow()
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func moveAbove(_ view: UIView) -> UIView? {
        defer {
            superview?.bringSubviewToFront(self)
        }

        if let superview = self.superview {
            if let sameLevelView = sequence(first: view, next: { $0.superview }).first(where: { $0.superview === superview }) {
                superview.insertSubview(self, aboveSubview: sameLevelView)
                return superview
            }
            else {
                view.superview?.insertSubview(self, aboveSubview: view)
                return view.superview
            }
        }
        else {
            guard let viewSuperview = view.superview else {
                return nil
            }
            viewSuperview.insertSubview(self, aboveSubview: view)
            return viewSuperview
        }
    }

    private func updateLayout(for view: UIView) {
        layout.reset()

        switch mode {
        case .horizontalBottom:
            layout.add(alignBottomAndSides(to: view))

        case .horizontalTop:
            layout.add(alignTopAndSides(to: view))

        case .vertical:
            layout.add(alignLeftAndSides(to: view))
        }

        layout.activate()
    }

    public func moveSelection(to view: UIView, animated: Bool) {
        let origSuperview = superview
        guard let commonAncestor = moveAbove(view) else { return }
        let animate = animated && (origSuperview === commonAncestor)

        guard animate else {
            updateLayout(for: view)
            commonAncestor.layoutIfNeeded()
            selectedView = view
            return
        }

        if let selectedView = selectedView {
            updateLayout(for: selectedView)
        }
        commonAncestor.layoutIfNeeded()
        selectedView = view

        UIView.animate(withDuration: 0.2) {
            self.updateLayout(for: view)
            commonAncestor.layoutIfNeeded()
        }
    }

    public override var intrinsicContentSize: CGSize {
        guard let style = currentStyle else {
            return super.intrinsicContentSize
        }

        switch mode {
        case .horizontalBottom, .horizontalTop:
            return CGSize(width: UIView.noIntrinsicMetric, height: style.thickness)
        case .vertical:
            return CGSize(width: style.thickness, height: UIView.noIntrinsicMetric)
        }
    }

    // Styling

    public typealias Style = Styling.SelectionIndicator
    public var currentStyle: Style?
    public var currentTraits: Styling.Traits?

    open class func style(_ traits: Styling.Traits) -> Style? { nil }

    open func applyStyle(_ style: Style) {
        backgroundColor = .color(for: style.color)
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
