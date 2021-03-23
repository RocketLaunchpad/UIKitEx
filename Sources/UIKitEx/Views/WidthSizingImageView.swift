//
//  WidthSizingImageView.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 1/16/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

open class WidthSizingImageView: UIImageView {
    private var lastWidth: CGFloat = 0

    public override var intrinsicContentSize: CGSize {
        guard let image = image else { return super.intrinsicContentSize }
        let width = bounds.width
        let height: CGFloat = width / image.size.aspectRatio
        return CGSize(width: width, height: height)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width != lastWidth else { return }
        lastWidth = bounds.width
        invalidateIntrinsicContentSize()
    }
}

#endif
