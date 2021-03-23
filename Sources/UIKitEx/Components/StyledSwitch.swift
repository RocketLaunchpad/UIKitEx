//
//  Switch.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 7/11/17.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public extension Styling {
    struct Switch {
        public var color: Color

        public init(color: Styling.Color) {
            self.color = color
        }
    }
}

open class StyledSwitch: UISwitch, AnyUIKitComponent {
    // Styling

    public typealias Style = Styling.Switch
    public var currentStyle: Style?
    public var currentTraits: Styling.Traits?

    open class func style(_ traits: Styling.Traits) -> Style? { nil }

    open func applyStyle(_ style: Style) {
        onTintColor = .color(for: style.color)
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
