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

public protocol InputView: UIView {
    var nextInputView: InputView? { get set }
    var previousInputView: InputView? { get set }
    @discardableResult func becomeFirstResponder() -> Bool
}

public extension UIView {
    private func subtreeInputViews() -> [InputView] {
        if let inputView = self as? InputView {
            return inputView.isHidden ? [] : [inputView]
        }

        return subviews.flatMap { $0.subtreeInputViews() }
    }

    func connectInputViews() {
        let inputViews = subtreeInputViews()
        for (prev, next) in zip(inputViews, inputViews.dropFirst()) {
            prev.nextInputView = next
            next.previousInputView = prev
        }
    }
}

extension UIResponder {
    @IBAction open func dismissKeyboardAndScrollContainerToEnd() {
        var resignedFirstResponder = false
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if resignedFirstResponder {
                // without calling scrollContainerToEnd() on the next
                // run loop iteration, the scrollview bottom inset becomes
                // invalid until the next scroll
                DispatchQueue.main.async {
                    self.scrollContainerToEnd()
                }
            }
        }
        resignedFirstResponder = resignFirstResponder()
        CATransaction.commit()
    }

    private func scrollContainerToEnd() {
        guard let view = self as? UIView else { return }
        guard let rootScrollView: RootScrollView = view.enclosingSuperview() else { return }
        rootScrollView.scrollToEnd()
    }
}

#endif
