//
//  UIEdgeInsets.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 6/30/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIEdgeInsets {
    init(offset: CGFloat) {
        self = Self.init(top: offset, left: offset, bottom: offset, right: offset)
    }

    static func edgeInsets(for insets: Styling.EdgeInsets) -> Self {
        return .init(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
    }

    static func horizontal(left: CGFloat, right: CGFloat) -> Self {
        return .init(top: 0, left: left, bottom: 0, right: right)
    }
}

#endif
