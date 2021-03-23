//
//  CGSize.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 2/1/18.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension CGSize {
    var isPortrait: Bool {
        return height >= width
    }
    
    var isLandscape: Bool {
        return !isPortrait
    }
    
    var maxSideLength: CGFloat {
        return max(width, height)
    }

    var aspectRatio: CGFloat {
        (height == 0) ? 0 : width / height
    }

    func applying(dx: CGFloat, dy: CGFloat) -> CGSize {
        .init(width: width + dx, height: height + dy)
    }
}

#endif
