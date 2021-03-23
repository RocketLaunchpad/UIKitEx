//
//  HtmlStyling.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 10/2/17.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import Foundation

public class HtmlText {
    private var html = ""
    private var indent = ""
    private var indentUnit = "  "
    private let indentUnitLength = 2
    
    public init(html: String = "", indent: String = "", indentUnit: String = "  ") {
        self.html = html
        self.indent = indent
        self.indentUnit = indentUnit
    }

    public func shiftRight() {
        indent.append(indentUnit)
    }
    
    public func shiftLeft() {
        indent.removeLast(indentUnitLength)
    }
    
    public func addLine(_ line: String) {
        html.append("\(indent)\(line)\n")
    }
    
    public func openTag(_ tag: String) {
        addLine("<\(tag)>")
        shiftRight()
    }
    
    public func closeTag(_ tag: String) {
        shiftLeft()
        addLine("</\(tag)>")
    }
    
    public func addStyle(_ tag: String, _ content: [String]) {
        addLine("\(tag) {")
        shiftRight()
        content.forEach { addLine($0) }
        shiftLeft()
        addLine("}")
    }
    
    public func addHtmlTag(_ tag: String, _ content: (HtmlText) -> Void) {
        openTag(tag)
        content(self)
        closeTag(tag)
    }
    
    public func addText(_ text: String) {
        html.append(text)
        html.append("\n")
    }
    
    public var value: String {
        return html
    }
}

public extension HtmlText {
    func addViewport() {
        addLine("<meta name='viewport' content='initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>")
    }

    func addAppFonts<T: FontStyling>(stylingType: T.Type) {
        for fontFaceInfo in stylingType.fontFaces() {
            addStyle(
                "@font-face", [
                    "font-family: \(fontFaceInfo.fontFamily);",
                    "src: url(\(fontFaceInfo.fileName));"
                ]
            )
        }
    }
}

#endif
