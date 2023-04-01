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

public typealias Layout = [NSLayoutConstraint]

public extension Layout {
    func activate() {
        NSLayoutConstraint.activate(self)
    }

    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }

    mutating func reset() {
        deactivate()
        removeAll()
    }

    @discardableResult
    mutating func add(_ value: NSLayoutConstraint?) -> NSLayoutConstraint? {
        guard let value = value else { return nil }
        append(value)
        return value
    }

    mutating func add(_ values: [NSLayoutConstraint]) {
        append(contentsOf: values)
    }
}

public extension NSLayoutConstraint {
    @discardableResult func activate() -> Self {
        self.isActive = true
        return self
    }

    @discardableResult func deactivate() -> Self {
        self.isActive = false
        return self
    }
}

public extension UIView {
    static func constraint<AnchorType: AnyObject, T: NSLayoutAnchor<AnchorType>>
        (_ anchor1: T, to anchor2: T, constant: CGFloat = 0, priority: UILayoutPriority = .required)
        -> NSLayoutConstraint
    {
        let res = anchor1.constraint(equalTo: anchor2, constant: constant)
        res.priority = priority
        return res
    }

    static func constraint<AnchorType: AnyObject, T: NSLayoutAnchor<AnchorType>>
        (_ anchor1: T, to anchor2: T, smallestConstant: CGFloat, priority: UILayoutPriority = .required)
        -> NSLayoutConstraint
    {
        let res = anchor1.constraint(greaterThanOrEqualTo: anchor2, constant: smallestConstant)
        res.priority = priority
        return res
    }

    static func constraint<AnchorType: AnyObject, T: NSLayoutAnchor<AnchorType>>
        (_ anchor1: T, to anchor2: T, largestConstant: CGFloat, priority: UILayoutPriority = .required)
        -> NSLayoutConstraint
    {
        let res = anchor1.constraint(lessThanOrEqualTo: anchor2, constant: largestConstant)
        res.priority = priority
        return res
    }

    func align<AnchorType: AnyObject, T: NSLayoutAnchor<AnchorType>>
        (_ keyPath: KeyPath<UIView, T>,
         toSameAnchorOf view2: UIView, offsetBy offset: CGFloat = 0, priority: UILayoutPriority = .required)
        -> NSLayoutConstraint
    {
        Self.constraint(self[keyPath: keyPath], to: view2[keyPath: keyPath], constant: offset, priority: priority)
    }

    private func align<AnchorType: AnyObject, T: NSLayoutAnchor<AnchorType>>
        (_ keyPath: KeyPath<UIView, T>,
         toSameAnchorOf view2: UIView, offsetByAtLeast offset: CGFloat, priority: UILayoutPriority = .required)
        -> NSLayoutConstraint
    {
        Self.constraint(self[keyPath: keyPath], to: view2[keyPath: keyPath], smallestConstant: offset, priority: priority)
    }

    func alignLeftEdge(to view2: UIView, insetBy inset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        align(\.leftAnchor, toSameAnchorOf: view2, offsetBy: inset, priority: priority)
    }

    func alignLeftEdge(toRightEdgeOf view2: UIView, offsetBy offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        UIView.constraint(leftAnchor, to: view2.rightAnchor, constant: offset, priority: priority)
    }

    func alignLeftEdge(to view2: UIView, insetByAtLeast inset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        align(\.leftAnchor, toSameAnchorOf: view2, offsetByAtLeast: inset, priority: priority)
    }

    func alignRightEdge(to view2: UIView, insetBy inset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        view2.align(\.rightAnchor, toSameAnchorOf: self, offsetBy: inset, priority: priority)
    }

    func alignRightEdge(to view2: UIView, insetByAtLeast inset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        view2.align(\.rightAnchor, toSameAnchorOf: self, offsetByAtLeast: inset, priority: priority)
    }

    func alignRightEdge(toLeftEdgeOf view2: UIView, offsetBy offset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        UIView.constraint(rightAnchor, to: view2.leftAnchor, constant: -offset, priority: priority)
    }

    func alignTopEdge(to view2: UIView, insetBy inset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        align(\.topAnchor, toSameAnchorOf: view2, offsetBy: inset, priority: priority)
    }

    func alignTopEdge(toBottomEdgeOf view2: UIView, offsetBy offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        UIView.constraint(topAnchor, to: view2.bottomAnchor, constant: offset, priority: priority)
    }

    func alignTopEdge(toBottomEdgeOf view2: UIView, offsetByAtLeast offset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        UIView.constraint(topAnchor, to: view2.bottomAnchor, smallestConstant: offset, priority: priority)
    }

    func alignTopEdge(toBottomEdgeOf view2: UIView, offsetByAtMost offset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        UIView.constraint(topAnchor, to: view2.bottomAnchor, largestConstant: offset, priority: priority)
    }

    func alignTopEdge(toSafeAreaOf view2: UIView, insetBy inset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        UIView.constraint(topAnchor, to: view2.safeAreaLayoutGuide.topAnchor, constant: inset, priority: priority)
    }

    func alignTopEdge(toSafeAreaOf view2: UIView, insetByAtLeast inset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        UIView.constraint(topAnchor, to: view2.safeAreaLayoutGuide.topAnchor, smallestConstant: inset, priority: priority)
    }

    func alignTopEdge(to view2: UIView, insetByAtLeast inset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        align(\.topAnchor, toSameAnchorOf: view2, offsetByAtLeast: inset, priority: priority)
    }

    func alignBottomEdge(to view2: UIView, insetBy inset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        align(\.bottomAnchor, toSameAnchorOf: view2, offsetBy: -inset, priority: priority)
    }

    func alignBottomEdge(to view2: UIView, insetByAtLeast inset: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        view2.align(\.bottomAnchor, toSameAnchorOf: self, offsetByAtLeast: inset, priority: priority)
    }

    func alignBottomEdge(toTopEdgeOf view2: UIView, offsetBy offset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        UIView.constraint(bottomAnchor, to: view2.topAnchor, constant: offset, priority: priority)
    }

    func alignBottomEdge(toSafeAreaOf view2: UIView, insetBy inset: CGFloat = 0, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        UIView.constraint(bottomAnchor, to: view2.safeAreaLayoutGuide.bottomAnchor, constant: -inset, priority: priority)
    }

    func alignFirstBaseline(to view2: UIView, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        align(\.firstBaselineAnchor, toSameAnchorOf: view2, priority: priority)
    }

    func alignFirstBaseline(toBottomEdgeOf view2: UIView, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        UIView.constraint(firstBaselineAnchor, to: view2.bottomAnchor, priority: priority)
    }

    func alignHorizontalCenter(to view2: UIView) -> NSLayoutConstraint {
        align(\.centerXAnchor, toSameAnchorOf: view2)
    }

    func alignVerticalCenter(to view2: UIView) -> NSLayoutConstraint {
        align(\.centerYAnchor, toSameAnchorOf: view2)
    }

    func alignVerticalCenter(to view2: UIView, multiplier: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: view2,
            attribute: .centerY,
            multiplier: multiplier,
            constant: 0
        )
    }

    func alignCenter(to view2: UIView) -> [NSLayoutConstraint] {
        [
            align(\.centerXAnchor, toSameAnchorOf: view2),
            align(\.centerYAnchor, toSameAnchorOf: view2)
        ]
    }

    func align(to view2: UIView, insetBy insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            alignLeftEdge(to: view2, insetBy: insets.left),
            alignRightEdge(to: view2, insetBy: insets.right),
            alignTopEdge(to: view2, insetBy: insets.top),
            alignBottomEdge(to: view2, insetBy: insets.bottom)
        ]
    }

    func align(to rect: CGRect, in view: UIView) -> [NSLayoutConstraint] {
        [
            alignLeftEdge(to: view, insetBy: rect.minX),
            alignTopEdge(to: view, insetBy: rect.minY),
            constraintWidth(to: rect.width),
            constraintHeight(to: rect.height)
        ]
    }

    func alignVerticalEdges(to view2: UIView, insetBy insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            alignLeftEdge(to: view2, insetBy: insets.left),
            alignRightEdge(to: view2, insetBy: insets.right)
        ]
    }

    func alignHorizontalEdges(to view2: UIView, insetBy insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            alignTopEdge(to: view2, insetBy: insets.top),
            alignBottomEdge(to: view2, insetBy: insets.bottom)
        ]
    }

    func alignTopAndSides(to view2: UIView, insetBy insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            alignTopEdge(to: view2, insetBy: insets.top),
            alignLeftEdge(to: view2, insetBy: insets.left),
            alignRightEdge(to: view2, insetBy: insets.right)
        ]
    }

    func alignBottomAndSides(to view2: UIView, insetBy insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            alignBottomEdge(to: view2, insetBy: insets.bottom),
            alignLeftEdge(to: view2, insetBy: insets.left),
            alignRightEdge(to: view2, insetBy: insets.right)
        ]
    }

    func alignLeftAndSides(to view2: UIView, insetBy insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            alignLeftEdge(to: view2, insetBy: insets.left),
            alignTopEdge(to: view2, insetBy: insets.top),
            alignBottomEdge(to: view2, insetBy: insets.bottom)
        ]
    }

    func alignRightAndSides(to view2: UIView, insetBy insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        [
            alignRightEdge(to: view2, insetBy: insets.right),
            alignTopEdge(to: view2, insetBy: insets.top),
            alignBottomEdge(to: view2, insetBy: insets.bottom)
        ]
    }

    func constraintHeight(to value: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let res = heightAnchor.constraint(equalToConstant: value)
        res.priority = priority
        return res
    }

    func constraintHeight(toAtMost value: CGFloat) -> NSLayoutConstraint {
        heightAnchor.constraint(lessThanOrEqualToConstant: value)
    }

    func constraintHeight(byAtLeast value: CGFloat) -> NSLayoutConstraint {
        heightAnchor.constraint(greaterThanOrEqualToConstant: value)
    }

    func constraintAspectRatio(to value: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let res = widthAnchor.constraint(equalTo: heightAnchor, multiplier: value)
        res.priority = priority
        return res
    }

    func constraintWidth(to value: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let res = widthAnchor.constraint(equalToConstant: value)
        res.priority = priority
        return res
    }

    func constraintWidth(toAtMost value: CGFloat) -> NSLayoutConstraint {
        widthAnchor.constraint(lessThanOrEqualToConstant: value)
    }

    func centerHorzontally(minInset: CGFloat) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            assertionFailure()
            return []
        }

        return [
            alignHorizontalCenter(to: superview),
            alignLeftEdge(to: superview, insetByAtLeast: minInset, priority: .required)
        ]
    }

}

public extension Layout {
    static func alignEdges(_ views: [UIView], constraint: (UIView, UIView) -> NSLayoutConstraint) -> [NSLayoutConstraint] {
        views.first.map { first in
            views.dropFirst().map {
                constraint(first, $0)
            }
        } ?? []
    }

    static func alignEdges<AnchorType: AnyObject, T: NSLayoutAnchor<AnchorType>>
        (_ views: [UIView], _ keyPath: KeyPath<UIView, T>)
        -> [NSLayoutConstraint]
    {
        alignEdges(views) { $0[keyPath: keyPath].constraint(equalTo: $1[keyPath: keyPath]) }
    }

    static func alignEdges(_ views: [UIView], _ constraints: [([UIView]) -> [NSLayoutConstraint]]) -> [NSLayoutConstraint] {
        constraints.flatMap { $0(views) }
    }

    static func alignLeadingEdges(_ views: [UIView]) -> [NSLayoutConstraint] {
        alignEdges(views, \.leadingAnchor)
    }

    static func alignTrailingEdges(_ views: [UIView]) -> [NSLayoutConstraint] {
        alignEdges(views, \.trailingAnchor)
    }

    static func alignTopEdges(_ views: [UIView]) -> [NSLayoutConstraint] {
        alignEdges(views, \.topAnchor)
    }

    static func alignBottomEdges(_ views: [UIView]) -> [NSLayoutConstraint] {
        alignEdges(views, \.bottomAnchor)
    }

    static func alignVerticalEdges(_ views: [UIView]) -> [NSLayoutConstraint] {
        alignEdges(views, [alignLeadingEdges, alignTrailingEdges])
    }

    static func alignHorizontalEdges(_ views: [UIView]) -> [NSLayoutConstraint] {
        alignEdges(views, [alignTopEdges, alignBottomEdges])
    }

    static func alignHorizontalCenters(_ views: [UIView]) -> [NSLayoutConstraint] {
        alignEdges(views, \.centerXAnchor)
    }

    static func alignVerticalCenters(_ views: [UIView]) -> [NSLayoutConstraint] {
        alignEdges(views, \.centerYAnchor)
    }

    static func alignTopAndSides(_ views: [UIView]) -> [NSLayoutConstraint] {
        alignEdges(views, [alignTopEdges, alignLeadingEdges, alignTrailingEdges])
    }

    static func alignBottomAndSides(_ views: [UIView]) -> [NSLayoutConstraint] {
        alignEdges(views, [alignBottomEdges, alignLeadingEdges, alignTrailingEdges])
    }
}

#endif

