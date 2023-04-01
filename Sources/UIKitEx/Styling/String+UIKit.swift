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

import FoundationEx
import UIKit

public extension String {
    func styled<F: FontStyling>(as style: Styling.Text<F>, isHTML: Bool = false) -> NSAttributedString {
        styledText(
            font: F.font(for: style.font),
            charSpacing: style.charSpacing,
            lineSpacing: style.lineSpacing,
            color: .maybeColor(for: style.color),
            alignment: .alignment(for: style.alignment),
            topOffset: style.topOffset,
            isHTML: isHTML
        )
    }

    func styledText(
        font: UIFont,
        charSpacing: CGFloat? = nil,
        lineSpacing: CGFloat? = nil,
        color: UIColor? = nil,
        alignment: NSTextAlignment? = nil,
        topOffset: CGFloat? = nil,
        isHTML: Bool = false
    )
        -> NSAttributedString
    {
        let attributes = String.styledTextAttributes(
            font: font,
            charSpacing: charSpacing,
            lineSpacing: lineSpacing,
            color: color,
            alignment: alignment,
            topOffset: topOffset
        )

        func basicAttributedString() -> NSAttributedString {
            return NSAttributedString(string: self, attributes: attributes)
        }

        guard isHTML else {
            return basicAttributedString()
        }

        let encoding: String.Encoding = .utf8
        guard let data = data(using: encoding, allowLossyConversion: true) else {
            return basicAttributedString()
        }

        guard let attributedString = (maybe {
            try NSMutableAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: encoding.rawValue],
                documentAttributes: nil
            )
        })
        else {
            return basicAttributedString()
        }

        let fullStringRange = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttributes(attributes, range: fullStringRange)
        return attributedString
    }

    static func styledTextAttributes(
        font: UIFont,
        charSpacing: CGFloat? = nil,
        lineSpacing: CGFloat? = nil,
        color: UIColor? = nil,
        alignment: NSTextAlignment? = nil,
        topOffset: CGFloat? = nil
    )
        -> [NSAttributedString.Key: Any]
    {
        var attributes: [NSAttributedString.Key: Any] = [:]

        attributes[.font] = font

        if let charSpacing = charSpacing {
            attributes[.kern] = charSpacing
        }

        let paragraphStyle = NSMutableParagraphStyle()
        if let lineSpacing = lineSpacing {
            paragraphStyle.minimumLineHeight = lineSpacing
            paragraphStyle.maximumLineHeight = lineSpacing
            paragraphStyle.lineBreakMode = .byTruncatingTail
        }
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }
        if let topOffset = topOffset {
            paragraphStyle.paragraphSpacingBefore = topOffset
        }
        attributes[.paragraphStyle] = paragraphStyle

        if let color = color {
            attributes[.foregroundColor] = color
        }

        return attributes
    }
}

#endif
