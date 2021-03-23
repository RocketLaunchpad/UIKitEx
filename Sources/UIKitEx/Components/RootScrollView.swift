//
//  RootScrollView.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 7/6/17.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
