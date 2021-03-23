//
//  TextStyling.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/19/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import Foundation
import CoreGraphics

public extension Styling {
    struct Text<F: FontStyling> {
        public enum Alignment {
            case left
            case center
        }

        public let font: F
        public var charSpacing: CGFloat?
        public var lineSpacing: CGFloat?
        public var color: Color?
        public var alignment: Alignment?
        public var topOffset: CGFloat?
        public var shadow: Shadow?

        public init(font: F, charSpacing: CGFloat? = nil, lineSpacing: CGFloat? = nil, color: Styling.Color? = nil, alignment: Styling.Text<F>.Alignment? = nil, topOffset: CGFloat? = nil, shadow: Styling.Shadow? = nil) {
            self.font = font
            self.charSpacing = charSpacing
            self.lineSpacing = lineSpacing
            self.color = color
            self.alignment = alignment
            self.topOffset = topOffset
            self.shadow = shadow
        }
    }

    typealias TextFunc<F: FontStyling> = (Traits) -> Text<F>
    typealias AttributedTextFunc = (Traits) -> NSAttributedString
}

#endif
