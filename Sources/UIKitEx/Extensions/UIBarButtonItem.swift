//
//  UIBarButtonItem.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 9/26/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UIBarButtonItem {
    func sendAction() {
        guard let action = action else { return }
        guard let target = target else { return }
        perform(action, with: target)
    }
}

#endif
