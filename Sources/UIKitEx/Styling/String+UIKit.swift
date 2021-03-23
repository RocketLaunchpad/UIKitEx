//
//  String+UIKit.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/19/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
