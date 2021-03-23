//
//  Error.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 03/30/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIKitEx {
    enum Error: Swift.Error {
        case general(String)
    }
}

#endif
