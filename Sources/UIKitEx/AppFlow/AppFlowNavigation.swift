//
//  AppFlowNavigation.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 2/27/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
