//
//  ReducerArchitectureVC.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 03/30/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit
import Combine
import CombineEx
import ReducerArchitecture

public protocol ReducerArchitectureVC: BasicReducerArchitectureVC, ConfigurableViewController, AsyncValueUI {
    func configureData()
    func configureViewHierarchy()
    func configureLayout()
    func updateLayout()
    func connectToStore()
    func connectToStoreAfterLayout()
}

public extension ReducerArchitectureVC {
    func configureData() {
    }

    func connectToStoreAfterLayout() {
    }

    func configure() {
        configureData()
        configureViewHierarchy()
        connectToStore()
        // layout configuration is separate to avoid
        // unwanted animations on first view appearance
    }

    func configureAfterLayout() {
        connectToStoreAfterLayout()
    }
}

public extension ReducerArchitectureVC where Self: BasicViewController {
    var value: AnyPublisher<Store.PublishedValue, Cancel> {
        store.value.merge(
            with: ended
                .filter { [unowned self] in
                    $0.isFromUI && !self.ignoreCancel
                }
                .tryMap { _ in
                    // print("cancel: \(self.store.identifier)")
                    throw Cancel.cancel
                }
                .forceErrorType(Cancel.self)
        )
        // .print(self.store.identifier)
        .eraseToAnyPublisher()
    }
}

#endif
