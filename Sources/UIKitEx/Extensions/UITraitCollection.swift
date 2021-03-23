//
//  UITraitCollection.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 1/8/18.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UITraitCollection {
    var isCompactSize: Bool {
        return (horizontalSizeClass != .regular) || (verticalSizeClass != .regular)
    }
}

public extension Styling.Traits {
    static func traits(_ traitCollection: UITraitCollection) -> Styling.Traits {
        let componentSize: Styling.ComponentSize
        switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
        case (.regular, .regular): componentSize = .regular
        default: componentSize = .compact
        }

        return Styling.Traits(
            componentSize: componentSize,
            separatorThickness: 1.0 / traitCollection.displayScale
        )
    }

    static var `default`: Styling.Traits {
        .traits(UITraitCollection.current)
    }
}

#endif
