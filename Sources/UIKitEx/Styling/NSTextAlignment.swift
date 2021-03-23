//
//  NSTextAlignment.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 6/21/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension NSTextAlignment {
    static func alignment<F: FontStyling>(for alignment: Styling.Text<F>.Alignment?) -> NSTextAlignment? {
        guard let alignment = alignment else { return nil }
        switch alignment {
        case .left: return .left
        case .center: return .center
        }
    }
}

#endif
