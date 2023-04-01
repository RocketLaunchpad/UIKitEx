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

import UIKit

public class RootScrollView: UIScrollView {
    private var savedBottomInset: CGFloat = 0
    private var isKeyboardShown = false

    private let keyboardManager = KeyboardManager()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        keyboardManager.scrollView = self
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        keyboardManager.scrollView = self
    }

    public func applyKeyboardBottomInset() {
        keyboardManager.applyKeyboardBottomInset()
    }

    public func moveToTop() {
        setContentOffset(.zero, animated: false)
    }

    public func scrollToEnd() {
        let rect = CGRect(x: 0, y: contentSize.height - 1, width: 1, height: 1)
        scrollRectToVisible(rect, animated: true)
    }

    public func trackKeyboard(enabled: Bool) {
        keyboardManager.trackKeyboard(enabled: enabled)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }

    public override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

#endif
