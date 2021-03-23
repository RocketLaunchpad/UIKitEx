//
//  UIControl.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 7/12/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//
// based on https://forums.swift.org/t/a-uicontrol-event-publisher-example/26215

#if canImport(UIKit)

import UIKit
import Combine
import CombineEx

public extension UIControl {
    private class EventObserver {
        let control: UIControl
        let event: UIControl.Event
        let subject: PassthroughSubject<UIControl, Never>

        init(control: UIControl, event: UIControl.Event) {
            self.control = control
            self.event = event
            self.subject = .init()
        }

        func start() {
            control.addTarget(self, action: #selector(handleEvent(from:)), for: event)
        }

        func stop() {
            control.removeTarget(self, action: nil, for: event)
        }

        @objc func handleEvent(from sender: UIControl) {
            subject.send(sender)
        }
    }

     struct ControlEventPublisher: Publisher {
        public typealias Output = UIControl
        public typealias Failure = Never

        public let control: UIControl
        public let event: UIControl.Event

        init(control: UIControl, event: UIControl.Event) {
            self.control = control
            self.event = event
        }

        public func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
            let observer = EventObserver(control: control, event: event)
            observer
                .subject
                .handleEvents(
                    receiveSubscription: { _ in observer.start() },
                    receiveCancel: observer.stop
                )
                .receive(subscriber: subscriber)
        }
    }

    func eventPublisher(for event: UIControl.Event) -> ControlEventPublisher {
        return ControlEventPublisher(control: self, event: event)
    }
}

#endif
