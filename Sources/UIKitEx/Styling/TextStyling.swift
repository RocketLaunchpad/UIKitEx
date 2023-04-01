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
