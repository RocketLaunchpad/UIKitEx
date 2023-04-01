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

import Foundation
import Combine
import CombineEx
import UIKit

public struct ActionInfo<T> {
    public init(description: String, action: @escaping () -> AnySingleValuePublisher<T, Never>) {
        self.description = description
        self.action = action
    }

    public let description: String
    public let action: () -> AnySingleValuePublisher<T, Never>
}

public protocol AsyncTaskUI: AppFlowViewController, ReplaceableInAppFlow, ReducerArchitectureVC {
    associatedtype E: Error
    static func make(message: String, asyncTask: @escaping () -> AnySingleValuePublisher<Store.PublishedValue, E>) -> Self
}

public protocol ActionPickerUI: UIViewController {
    associatedtype T
    var done: AnySingleValuePublisher<ActionInfo<T>, Never> { get }
    static func make(title: String, description: String, actions: [ActionInfo<T>]) -> Self
}

public extension AppFlow {
    static func run<C: AsyncTaskUI, T, E>(
        message: String,
        asyncTask: @escaping () -> AnySingleValuePublisher<T, E>,
        containerType: C.Type,
        minDelay: TimeInterval = 0.4,
        on nc: UINavigationController
    )
    -> AnySingleValuePublisher<T, Cancel>
    where C.Store.PublishedValue == T, C.E == E
    {
        let asyncTaskVC = containerType.make(message: message, asyncTask: asyncTask)
        showVC(asyncTaskVC, on: nc)
        let timer = AppFlow.delay(for: .seconds(minDelay)).addUserCanCancel()
        return asyncTaskVC.value.first().zip(timer).map { $0.0 }.eraseType()
    }

    static func run<C: AsyncTaskUI, T>(
        message: String,
        asyncTask: @escaping () -> AnySingleValuePublisher<T, Never>,
        containerType: C.Type,
        on nc: UINavigationController
    )
    -> AnySingleValuePublisher<T, Never>
    where C.Store.PublishedValue == T
    {
        run(
            message: message,
            asyncTask: { asyncTask().addErrorType(C.E.self).eraseType() },
            containerType: containerType,
            on: nc
        )
        .assertNoFailure()
        .eraseType()
    }

    static func run<T, TaskError: Error, WrappedError: Error>(
        task: @escaping () -> CachedSingleValuePublisher<T, TaskError>,
        wrapIfNotCached wrapper: (@escaping () -> AnySingleValuePublisher<T, TaskError>) -> AnySingleValuePublisher<T, WrappedError>
    )
    -> AnySingleValuePublisher<T, WrappedError>
    {
        if let value = task().cachedValue {
            return Just(value).addErrorType(WrappedError.self).eraseType()
        }

        return wrapper { task().unwrap() }
    }

    static func runSelectedAction<C: ActionPickerUI, T>(
        title: String,
        description: String,
        actions: [ActionInfo<T>],
        pickerType: C.Type,
        selectOn vc: UIViewController
    )
    -> AnySingleValuePublisher<T, Never>
    where C.T == T
    {
        let pickerVC = C.make(title: title, description: description, actions: actions)

        vc.present(pickerVC, animated: true)
        return pickerVC.done
            .sideEffect { [weak vc] _ in
                guard let vc = vc else { return }
                (vc as? BasicViewController)?.endValue = .fromCode
                vc.dismiss(animated: true)
            }
            .flatMapLatest { $0.action() }
            .eraseType()
    }
}

#endif
