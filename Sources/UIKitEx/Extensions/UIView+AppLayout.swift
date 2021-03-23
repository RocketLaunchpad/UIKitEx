//
//  UIView+AppLayout.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 7/14/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
