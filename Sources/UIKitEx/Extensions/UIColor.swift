//
//  UIColor.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 6/21/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIColor {
    static func maybeColor(for style: Styling.Color?) -> UIColor? {
        guard let style = style else { return nil }
        return .color(for: style)
    }

    static func color(for style: Styling.Color) -> UIColor {
        return UIColor(red: style.red, green: style.green, blue: style.blue, alpha: style.opacity)
    }
}

#endif
