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
