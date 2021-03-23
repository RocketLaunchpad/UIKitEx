//
//  ConfigurableViewController.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 03/30/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public protocol ConfigurableViewController: UIViewController {
    /// Configures the data flow and the view hierarchy
    func configure()

    /// Configures the layout but assumes a call to `updateLayout` to finish setup
    func configureLayout()

    /// Updates the layout for the current traits
    func updateLayout()

    /// Configures the rest of the UI after initial layout.
    /// (necessary on iOS 13 for UICollectionView)
    func configureAfterLayout()
}

public extension ConfigurableViewController {
    func configureAfterLayout() {
    }
}

#endif
