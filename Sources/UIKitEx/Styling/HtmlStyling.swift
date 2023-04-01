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
