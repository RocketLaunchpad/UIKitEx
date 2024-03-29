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
