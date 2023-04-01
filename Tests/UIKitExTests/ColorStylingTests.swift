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

import XCTest
import UIKitEx

class ColorStylingTests: XCTestCase {
    func testHexBlack() throws {
        let color = try Styling.Color(hex: "#000000FF")
        XCTAssertEqual(color.red, 0)
        XCTAssertEqual(color.green, 0)
        XCTAssertEqual(color.blue, 0)
        XCTAssertEqual(color.opacity, 1)
    }

    func testHexRed() throws {
        let color = try Styling.Color(hex: "#FF0000FF")
        XCTAssertEqual(color.red, 1)
        XCTAssertEqual(color.green, 0)
        XCTAssertEqual(color.blue, 0)
        XCTAssertEqual(color.opacity, 1)
    }

    func testHexGreen() throws {
        let color = try Styling.Color(hex: "#00FF00FF")
        XCTAssertEqual(color.red, 0)
        XCTAssertEqual(color.green, 1)
        XCTAssertEqual(color.blue, 0)
        XCTAssertEqual(color.opacity, 1)
    }

    func testHexBlue() throws {
        let color = try Styling.Color(hex: "#0000FFFF")
        XCTAssertEqual(color.red, 0)
        XCTAssertEqual(color.green, 0)
        XCTAssertEqual(color.blue, 1)
        XCTAssertEqual(color.opacity, 1)
    }

    func testMixed() throws {
        let color = try Styling.Color(hex: "C0D6E4C3")
        XCTAssertEqual(color.red, 192.0 / 255.0)
        XCTAssertEqual(color.green, 214.0 / 255.0)
        XCTAssertEqual(color.blue, 228.0 / 255.0)
        XCTAssertEqual(color.opacity, 195.0 / 255.0)
    }

    func testOpacity() throws {
        let color = try Styling.Color(hex: "C0D6E4", opacity: 195.0 / 255.0)
        XCTAssertEqual(color.red, 192.0 / 255.0)
        XCTAssertEqual(color.green, 214.0 / 255.0)
        XCTAssertEqual(color.blue, 228.0 / 255.0)
        XCTAssertEqual(color.opacity, 195.0 / 255.0)
    }

    func testAsLiteral() {
        let _: Styling.Color = "#C0D6E4C3"
    }
}
