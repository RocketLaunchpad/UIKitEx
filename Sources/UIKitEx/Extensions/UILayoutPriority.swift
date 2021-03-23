//
//  UILayoutPriority.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 11/1/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UILayoutPriority {
    static let almostRequired: Self = .init(rawValue: Self.required.rawValue - 1)
}

#endif
