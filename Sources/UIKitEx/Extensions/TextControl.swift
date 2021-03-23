//
//  TextControl.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/18/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit
import Combine
import CombineEx

public protocol TextControl: UIView, UITextInput {
    static var textDidChangeNotification: Notification.Name { get }
    static var textDidBeginEditingNotification: Notification.Name { get }
    static var textDidEndEditingNotification: Notification.Name { get }
    var textValue: String? { get set }
}

public extension TextControl {
    var textDidChangePublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: Self.textDidChangeNotification, object: self)
            .compactMap { [weak self] _ in
                self?.textValue ?? ""
            }
            .eraseToAnyPublisher()
    }

    var textDidBeginEditingPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default
            .publisher(for: Self.textDidBeginEditingNotification, object: self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    var textDidEndEditingPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default
            .publisher(for: Self.textDidEndEditingNotification, object: self)
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    func update(_ value: String) {
        textValue = value
    }
}

#endif
