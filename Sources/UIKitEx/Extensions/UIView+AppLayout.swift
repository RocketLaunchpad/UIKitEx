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

public extension UIView {
    private static func maxAvailableWidth(traits: Styling.Traits, availableSize: CGSize, insetsTotal: CGFloat) -> CGFloat {
        min(max(0, availableSize.width - insetsTotal), availableSize.isLandscape ? 580 : 460)
    }

    static func mainContentFill(view: UIView, traits: Styling.Traits, availableSize: CGSize, insetBy insets: UIEdgeInsets = .zero) -> Layout {
        guard let superview = view.superview else {
            assertionFailure()
            return []
        }
        return view.alignVerticalEdges(to: superview, insetBy: insets)
    }

    static func mainContentCenter(view: UIView, traits: Styling.Traits, availableSize: CGSize, minInset: CGFloat) -> Layout {
        let maxWidth = maxAvailableWidth(traits: traits, availableSize: availableSize, insetsTotal: 2.0 * minInset)
        var layout = Layout()
        layout.add(view.constraintWidth(to: maxWidth, priority: .required))
        layout.add(view.centerHorzontally(minInset: minInset))
        return layout
    }

    static func mainContentRight(view: UIView, traits: Styling.Traits, availableSize: CGSize, minInset: CGFloat) -> Layout {
        guard let superview = view.superview else {
            assertionFailure()
            return Layout()
        }

        let maxWidth = maxAvailableWidth(traits: traits, availableSize: availableSize, insetsTotal: 0)
        var layout = Layout()
        layout.add(view.constraintWidth(to: maxWidth, priority: .required))
        layout.add(view.alignRightEdge(to: superview))
        return layout
    }
}

#endif
