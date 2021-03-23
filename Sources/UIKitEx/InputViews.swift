//
//  InputViews.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 8/22/17.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
