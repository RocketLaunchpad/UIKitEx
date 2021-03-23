//
//  ColorStylingTests.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 6/19/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
