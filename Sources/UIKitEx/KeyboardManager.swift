//
//  KeyboardManager.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 11/15/17.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
