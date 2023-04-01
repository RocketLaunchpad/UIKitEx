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

class KeyboardManager {
    private var savedBottomInset: CGFloat = 0
    private var keyboardBottomInset: CGFloat = 0
    private var isKeyboardShown = false

    func trackKeyboard(enabled: Bool) {
        let nc = NotificationCenter.default
        if enabled {
            nc.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            nc.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
            nc.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        }
        else {
            nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            nc.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
            nc.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        }
    }

    weak var scrollView: UIScrollView?

    private func applyBottomInset(_ inset: CGFloat) {
        guard let scrollView = scrollView else { return }
        scrollView.contentInset.bottom = inset
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    func applyKeyboardBottomInset() {
        applyBottomInset(keyboardBottomInset)
    }

    private func applySavedBottomInset() {
        applyBottomInset(savedBottomInset)
    }

    private func updateKeyboardBottomInset(keyboardRect: CGRect) {
        guard let scrollView = scrollView else { return }
        guard let window = scrollView.window else { return }
        let offsetFromBottom = window.bounds.maxY - window.convert(scrollView.bounds, from: scrollView).maxY
        keyboardBottomInset = keyboardRect.height - offsetFromBottom - scrollView.safeAreaInsets.bottom
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let scrollView = scrollView else { return }
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        if !isKeyboardShown {
            savedBottomInset = scrollView.contentInset.bottom
        }
        updateKeyboardBottomInset(keyboardRect: keyboardRect)
        isKeyboardShown = true
    }

    @objc private func keyboardDidHide(_ notification: NSNotification) {
        applySavedBottomInset()
        keyboardBottomInset = savedBottomInset
        isKeyboardShown = false
    }

    @objc private func keyboardDidChangeFrame(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        updateKeyboardBottomInset(keyboardRect: keyboardRect)
    }
}

#endif
