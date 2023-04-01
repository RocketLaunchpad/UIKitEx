//
// Copyright (c) 2023 DEPT Digital Products, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
    @MainActor
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
