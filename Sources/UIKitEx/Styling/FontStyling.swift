//
//  FontStyling.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/19/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public struct FontFaceInfo {
    public let fontFamily: String
    public let fileName: String

    public init(fontFamily: String, fileName: String) {
        self.fontFamily = fontFamily
        self.fileName = fileName
    }
}

public protocol FontStyling {
    static func font(for style: Self) -> UIFont
    static func fontFaces() -> [FontFaceInfo]
    static func `default`(_ traits: Styling.Traits) -> Self
}

#endif
