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

public protocol ResizableContentView: UIView {
    var preferredSortedHeights: [CGFloat] { get }
    var canScrollDown: Bool { get }
    var canScrollUp: Bool { get }
}

public protocol AnyResiableView: UIView {
    func minimize()
    func maximize()
}

open class ResizableView<V: ResizableContentView>: UIView, AnyResiableView, ContainerView, UIGestureRecognizerDelegate {
    public enum FixedEdge {
        case top, bottom
    }

    public private(set) var fixedEdge: FixedEdge

    public private(set) var contentView: V
    private var height: NSLayoutConstraint!
    private var heightBeforeDrag: CGFloat = 0 // height.constant before drag
    private var preferredSortedHeights: [CGFloat] = [0]

    private let minThresholdVelocity: CGFloat = 500

    // location in superview
    private var dragStartLocation: CGPoint = .zero

    private var panGestureRecognizer: UIPanGestureRecognizer!

    func updatePreferredSortedHeights() {
        preferredSortedHeights = contentView.preferredSortedHeights
        guard !preferredSortedHeights.isEmpty else {
            assertionFailure()
            return
        }

        func changeHeight(to newHeight: CGFloat) {
            height.constant = newHeight
            layoutContainerView()?.layoutIfNeeded()
        }

        func replaceWithActualHeight(index: Int) {
            changeHeight(to: preferredSortedHeights[index])
            preferredSortedHeights[index] = frame.height
        }

        layoutContainerView()?.setNeedsLayout()
        layoutContainerView()?.layoutIfNeeded()
        let currentHeight = frame.height

        let firstIndex = 0
        replaceWithActualHeight(index: firstIndex)
        let firstHeight = preferredSortedHeights[firstIndex]
        preferredSortedHeights.removeAll(where: { $0 < firstHeight })

        let lastIndex = preferredSortedHeights.count - 1
        replaceWithActualHeight(index: lastIndex)
        let lastHeight = preferredSortedHeights[lastIndex]
        preferredSortedHeights.removeAll(where: { $0 > lastHeight })

        changeHeight(to: currentHeight)
    }

    private func closestPreferredHeight(to height: CGFloat) -> CGFloat {
        var closestHeight = preferredSortedHeights[0]
        for indexHeight in preferredSortedHeights.dropFirst() {
            if abs(indexHeight - height) < abs(closestHeight - height) {
                closestHeight = indexHeight
            }
        }
        return closestHeight
    }

    private func closestPreferredHeight(to height: CGFloat, velocity: CGFloat) -> CGFloat {
        guard velocity != 0 else { return height }
        switch (fixedEdge, velocity > 0) {
        case (.bottom, true), (.top, false):
            return preferredSortedHeights.reversed().first { $0 <= height } ?? height
        case (.bottom, false), (.top, true):
            return preferredSortedHeights.first { $0 >= height } ?? height
        }
    }

    private func layoutContainerView() -> UIView? {
        guard let superview = superview else { return nil }
        var res: UIView?
        for view in sequence(first: superview, next: { $0.superview }) where view is ContainerView {
            res = view
        }
        return res?.superview ?? res ?? superview
    }

    func resize(to newHeight: CGFloat) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: []) {
            self.height.constant = newHeight
            self.heightBeforeDrag = newHeight
            self.layoutContainerView()?.layoutIfNeeded()
        }
    }

    public func minimize() {
        guard let minHeight = preferredSortedHeights.first else {
            assertionFailure()
            return
        }
        resize(to: minHeight)
    }

    public func maximize() {
        guard let maxHeight = preferredSortedHeights.last else {
            assertionFailure()
            return
        }
        resize(to: maxHeight)
    }

    @IBAction func handleDrag(_ gr: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        handleDrag(gr, in: superview)
    }

    func handleDrag(_ gr: UIPanGestureRecognizer, in view: UIView) {
        let point = gr.translation(in: view)
        let velocity = gr.velocity(in: view).y

        // print("state: \(gr.state.rawValue), velocity: \(velocity)")

        switch gr.state {
        case .began:
            heightBeforeDrag = frame.height
            dragStartLocation = point

        case .possible, .changed, .ended:
            let dy: CGFloat
            switch fixedEdge {
            case .top:
                dy = point.y - dragStartLocation.y
            case .bottom:
                dy = dragStartLocation.y - point.y
            }

            let minHeight = preferredSortedHeights.first ?? 0
            let maxHeight = preferredSortedHeights.last ?? 0

            var newHeight = heightBeforeDrag + dy
            newHeight = max(minHeight, newHeight)
            newHeight = min(newHeight, maxHeight)

            if (gr.state == .ended) && (abs(velocity) > minThresholdVelocity) {
                resize(to: closestPreferredHeight(to: newHeight, velocity: velocity))
            }
            else {
                height.constant = newHeight
                if case .ended = gr.state {
                    resize(to: closestPreferredHeight(to: newHeight))
                }
            }

        case .cancelled, .failed:
            height.constant = heightBeforeDrag

        @unknown default:
            break
        }
    }

    public init(_ contentView: V, fixedEdge: FixedEdge) {
        self.contentView = contentView
        self.fixedEdge = fixedEdge

        super.init(frame: .zero)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)

        var layout = Layout()
        height = layout.add(constraintHeight(to: frame.size.height, priority: .almostRequired))
        layout.add(contentView.align(to: self))
        layout.activate()

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)

        preferredSortedHeights = contentView.preferredSortedHeights
        minimize()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIGestureRecognizerDelegate

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        assert(gestureRecognizer === panGestureRecognizer)

        let velocity = panGestureRecognizer.velocity(in: superview).y
        guard velocity != 0 else { return false }

        let canScrollContentView: Bool
        switch fixedEdge {
        case .top:
            canScrollContentView = contentView.canScrollDown
        case .bottom:
            canScrollContentView = contentView.canScrollUp
        }

        updatePreferredSortedHeights()
        let minHeight = preferredSortedHeights.first ?? 0
        let maxHeight = preferredSortedHeights.last ?? 0

        switch (fixedEdge, velocity > 0) {
        case (.bottom, true), (.top, false):
            return (heightBeforeDrag > minHeight) && !canScrollContentView
        case (.bottom, false), (.top, true):
            return (heightBeforeDrag < maxHeight ) && !canScrollContentView
        }
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer)
    -> Bool
    {
        guard gestureRecognizer == panGestureRecognizer else { return false }
        guard let scrollView = otherGestureRecognizer.view as? UIScrollView else { return false }
        guard scrollView.isDescendant(of: self) else { return false }
        return true
    }
}

#endif
