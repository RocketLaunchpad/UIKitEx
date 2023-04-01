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

