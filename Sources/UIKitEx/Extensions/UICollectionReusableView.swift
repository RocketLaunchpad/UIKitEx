//
//  UICollectionReusableView.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 12/22/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UICollectionReusableView {
    func measure(availableSize: CGSize) -> CGSize {
        frame = CGRect(origin: .zero, size: availableSize)
        setNeedsLayout()
        layoutIfNeeded()
        let size = systemLayoutSizeFitting(availableSize)
        return size
    }
}

#endif
