//
//  SelfSizingImageView.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 9/25/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

open class SelfSizingImageView: UIImageView {
    private var aspectRatio: NSLayoutConstraint?

    private func updateAspectRatio(image: UIImage) {
        let value = image.size.aspectRatio
        if let aspectRatio = aspectRatio {
            aspectRatio.constant = value
        }
        else {
            aspectRatio = self.constraintAspectRatio(to: value, priority: .almostRequired).activate()
        }
    }

    public override var image: UIImage? {
        didSet {
            guard let image = image else { return }
            updateAspectRatio(image: image)
        }
    }
}

#endif
