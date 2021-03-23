//
//  NSMutableAttributedString.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 7/14/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import Foundation

public extension NSMutableAttributedString {
    func emphasize<F: FontStyling>(_ text: String, as style: Styling.Text<F>) {
        let textRange = (string as NSString).range(of: text)
        let formattedText = text.styled(as: style)
        replaceCharacters(in: textRange, with: formattedText)
    }
}

#endif
