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
