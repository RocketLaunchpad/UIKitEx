//
//  ColorStyling.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/18/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

import CoreGraphics
import FoundationEx

public extension Styling {
    struct Color {
        public var red, green, blue, opacity: CGFloat

        public var htmlHex: String {
            func intVal(_ arg: CGFloat) -> Int {
                Int(round(arg * 255))
            }

            if opacity != 1 {
                return String(format: "#%02lX%02lX%02lX%02lX", intVal(red), intVal(green), intVal(blue), intVal(opacity))
            } else {
                return String(format: "#%02lX%02lX%02lX", intVal(red), intVal(green), intVal(blue))
            }
        }
    }
}

public extension Styling.Color {
    static let clear: Self = .literal(hex: "000000", opacity: 0)
    static let white: Self = "FFFFFF"
    static let black: Self = "000000"
    static let separator: Self = .literal(hex: "69737B", opacity: 0.2)
    static let dimmed: Self = .literal(hex: "000000", opacity: 0.4)
}

extension Styling.Color: ExpressibleByStringLiteral {
    public enum ParseHexError: Error {
        case mustStartWithHash
        case invalidCharCount
        case invalidComponentFormat
        case invalidArgs
    }

    public init(hex: String, opacity: CGFloat? = nil) throws {
        let parsedOpacity: CGFloat
        (red, green, blue, parsedOpacity) = try hex.parseAsHexColor()
        self.opacity = opacity ?? parsedOpacity
    }

    public static func literal(hex: String, opacity: CGFloat) -> Self {
        do {
            return try .init(hex: hex, opacity: opacity)
        }
        catch {
            fatalError("\(error)")
        }
    }

    public init(stringLiteral hex: String) {
        do {
            self = try .init(hex: String(hex))
        }
        catch {
            fatalError("\(error)")
        }
    }
}
