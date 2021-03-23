//
//  UITabBarController.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 2/3/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public extension UITabBarController {
    func index(of vc: UIViewController) -> Int? {
        viewControllers?.firstIndex(of: vc)
    }

    func selectTab(named name: String) throws {
        func match(item: UITabBarItem?) -> Bool {
            guard let title = item?.title else { return false }
            return title.caseInsensitiveCompare(name) == .orderedSame
        }
        guard let tabIndex = tabBar.items?.firstIndex(where: match) else {
            throw UIKitEx.Error.general("no tab named \(name)")
        }
        selectedIndex = tabIndex
    }

    func select(_ vc: UIViewController) {
        guard let index = index(of: vc) else { return assertionFailure() }
        selectedIndex = index
    }
}

#endif
