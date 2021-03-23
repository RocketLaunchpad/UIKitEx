//
//  UNUserNotificationCenter.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 2/14/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import Foundation
import Combine
import CombineEx
import UserNotifications

public extension UNUserNotificationCenter {
    func getAccess(options: UNAuthorizationOptions = []) -> LazyFuture<Bool, Never> {
        .init { [weak self] promise in
            guard let self = self else { return promise(.success(false)) }
            self.requestAuthorization(options: options) { granted, _ in
                promise(.success(granted))
            }
        }
    }
}

#endif
