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
