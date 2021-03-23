//
//  AppFlow.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 7/19/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import Combine
import CombineEx
import UIKit

public protocol SingleValueFlow {
    associatedtype Value
    associatedtype AsyncValue: SingleValuePublisher where AsyncValue.Output == Value
    func run() -> AsyncValue
}

public protocol ReplaceableInAppFlow: UIViewController {}

public protocol AppFlowViewController: UIViewController {
    func configureBackButton(_ nc: UINavigationController)
    func cancel()
}

public typealias AsyncValueUIasFlowVC = AsyncValueUI & AppFlowViewController

public enum AppFlow {
    public typealias FinshedActionPublisher = AnySingleValuePublisher<Void, Never>
    public typealias CancellableFinshedActionPublisher = AnySingleValuePublisher<Void, Cancel>
    public static let finishedAction: FinshedActionPublisher = Just(()).eraseType()
    public static let cancellableFinishedAction: CancellableFinshedActionPublisher = Just(()).addUserCanCancel().eraseType()
    public static let noAction = Just(()).eraseType()
    public static let cancellableNoAction = Just(()).addUserCanCancel().eraseType()

    public static func start() -> Just<Void> {
        Just(())
    }

    public static func never<T, E: Error>() -> AnySingleValuePublisher<T, E> {
        Combine.Empty(completeImmediately: false).eraseType()
    }

    public static func cancel<T>() -> AnySingleValuePublisher<T, Cancel> {
        Fail(error: .cancel).eraseType()
    }

    public static func cancel<T>() -> AnyPublisher<T, Cancel> {
        Fail(error: .cancel).eraseToAnyPublisher()
    }
}

public extension Publisher where Failure == Never {
    func addUserCanCancel() -> Publishers.MapError<Self, Cancel> {
        addErrorType(Cancel.self)
    }
}

public extension Publisher where Output == Void, Failure == Cancel {
    func catchCancelAsVoid() -> Publishers.ReplaceError<Self> {
        replaceError(with: ())
    }
}

#endif

