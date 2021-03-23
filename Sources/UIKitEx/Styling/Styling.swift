//
//  Styling.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/18/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

import Foundation
import CoreGraphics

public struct Styling {
    public static var standardNavigationDelay: TimeInterval = 0.5
    public static var standardPresentationDelay: TimeInterval = 0.1

    public enum ComponentSize {
        case compact, regular
    }

    public struct Traits {
        public let componentSize: ComponentSize
        public let separatorThickness: CGFloat

        public init(componentSize: Styling.ComponentSize, separatorThickness: CGFloat) {
            self.componentSize = componentSize
            self.separatorThickness = separatorThickness
        }
    }

    public struct EdgeInsets {
        public init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
            self.top = top
            self.left = left
            self.bottom = bottom
            self.right = right
        }

        public var top, left, bottom, right: CGFloat
    }

    public struct Shadow {
        public init(offset: CGSize, radius: CGFloat, opacity: Float) {
            self.offset = offset
            self.radius = radius
            self.opacity = opacity
        }

        public var offset: CGSize
        public var radius: CGFloat
        public var opacity: Float
    }

    public struct View {
        public init(width: CGFloat? = nil, height: CGFloat? = nil, backgroundColor: Styling.Color? = nil, opacity: CGFloat? = nil, borderWidth: CGFloat? = nil, borderColor: Styling.Color? = nil, cornerRadius: CGFloat? = nil, shadow: Styling.Shadow? = nil) {
            self.width = width
            self.height = height
            self.backgroundColor = backgroundColor
            self.opacity = opacity
            self.borderWidth = borderWidth
            self.borderColor = borderColor
            self.cornerRadius = cornerRadius
            self.shadow = shadow
        }

        public var width: CGFloat?
        public var height: CGFloat?
        public var backgroundColor: Color?
        public var opacity: CGFloat?
        public var borderWidth: CGFloat?
        public var borderColor: Color?
        public var cornerRadius: CGFloat?
        public var shadow: Shadow?
    }

    public struct LinearGradient {
        public init(colors: [Styling.Color], startPoint: CGPoint, endPoint: CGPoint) {
            self.colors = colors
            self.startPoint = startPoint
            self.endPoint = endPoint
        }

        var colors: [Color]
        var startPoint: CGPoint
        var endPoint: CGPoint
    }
}

extension Styling.Traits: Equatable {}

public extension Styling.EdgeInsets {
    static let zero: Self = .init(top: 0, left: 0, bottom: 0, right: 0)
}
