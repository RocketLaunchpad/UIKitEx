//
//  SelfSizingCollectionView.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 8/29/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

open class SelfSizingCollectionView: UICollectionView {
    private var height: NSLayoutConstraint?

    private func updateHeight() {
        let contentHeight = max(contentSize.height, 1)
        if let height = height {
            height.constant = contentHeight
        }
        else {
            height = constraintHeight(to: contentHeight, priority: .almostRequired).activate()
        }
    }

    public override var contentSize: CGSize {
        didSet {
            updateHeight()
        }
    }
}

#endif
