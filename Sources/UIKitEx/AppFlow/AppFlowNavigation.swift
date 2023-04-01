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

public extension AppFlow {
    static func delay(for interval: DispatchQueue.SchedulerTimeType.Stride) -> AnySingleValuePublisher<Void, Never> {
        Just(()).delay(for: interval, scheduler: DispatchQueue.main).eraseType()
    }

    static let standardPresentationDelay = delay(for: .seconds(Styling.standardPresentationDelay))

    static func getStartVC(on nc: UINavigationController) -> UIViewController {
        if let startVC = nc.viewControllers.reversed().first(where: { vc in
            (vc is AppFlowViewController) && !(vc is ReplaceableInAppFlow)
        })
        .flatMap({ $0 as? AppFlowViewController }) {
            return startVC
        }
        else if let vc = nc.topViewController {
            return vc
        }
        else {
            fatalError()
        }
    }

    static func vcAfter(_ vc: UIViewController, on nc: UINavigationController) -> UIViewController? {
        zip(nc.viewControllers, nc.viewControllers.dropFirst()).first { $0.0 == vc }?.1
    }

    static func vcBefore(_ vc: UIViewController, on nc: UINavigationController) -> UIViewController? {
        zip(nc.viewControllers, nc.viewControllers.dropFirst()).first { $0.1 == vc }?.0
    }

    static func show<UI: AsyncValueUIasFlowVC>(_ vc: UI, on nc: UINavigationController) -> AnyPublisher<UI.Value, Cancel> {
        showVC(vc, on: nc)
        vc.configureBackButton(nc)
        return vc.value
    }

    static func showVC(_ vc: UIViewController, on nc: UINavigationController) {
        if let topVC = nc.topViewController as? ReplaceableInAppFlow {
            topVC.replace(by: vc)
        }
        else {
            let animated = !nc.viewControllers.isEmpty
            nc.pushViewController(vc, animated: animated)
        }
    }

    static func pop(to vc: UIViewController, delayFor time: TimeInterval = 0) -> FinshedActionPublisher {
        guard let nc = vc.navigationController else {
            assertionFailure()
            return finishedAction
        }

        nc.viewControllers
            .reversed()
            .prefix(while: {$0 != vc})
            .forEach { ($0 as? BasicViewController)?.endValue = .fromCode }

        nc.popToViewController(vc, animated: true)
        if time > 0 {
            return finishedAction
                .delay(for: .seconds(time), scheduler: DispatchQueue.main)
                .eraseType()
        }
        else {
            return finishedAction
        }
    }

    static func popToRoot(of nc: UINavigationController, delayFor time: TimeInterval = 0) -> FinshedActionPublisher {
        guard let firstVC = nc.viewControllers.first else { return finishedAction }
        return pop(to: firstVC, delayFor: time)
    }
}

#endif
