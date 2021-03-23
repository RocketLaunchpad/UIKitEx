//
//  AsyncValueUI.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 03/30/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

import Combine
import CombineEx

public protocol AsyncValueUI {
    associatedtype Value
    var value: AnyPublisher<Value, Cancel> { get }
}
