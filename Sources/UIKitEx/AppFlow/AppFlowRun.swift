//
//  AppFlowRun.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 2/27/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

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
