//
//  UIScrollView.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 11/8/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIScrollView {
    var isAtTop: Bool {
        contentOffset.y <= -contentInset.top
    }

    var isAtBottom: Bool {
        contentOffset.y + bounds.height >= contentSize.height + contentInset.bottom
    }
}

#endif
