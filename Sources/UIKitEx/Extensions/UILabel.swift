//
//  UILabel.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 6/21/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UILabel {
    func addTextShadow(_ shadow: Styling.Shadow) {
        addShadow(shadow)
    }

    func removeTextShadow() {
        addShadow(nil)
    }
}

#endif
