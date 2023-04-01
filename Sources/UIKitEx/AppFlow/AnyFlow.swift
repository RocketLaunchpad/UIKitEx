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

import UIKit
import Combine
import CombineEx

public struct AnyFlow {
    public enum Mode {
        case presentation
        case inPlace
        case embedded

        public var isPresentation: Bool {
            switch self {
            case .presentation:
                return true
            default:
                return false
            }
        }

        public var canAddPromptAtEnd: Bool {
            switch self {
            case .presentation, .inPlace:
                return true
            case .embedded:
                return false
            }
        }
    }

    public let nc: UINavigationController
    public var start: () -> AppFlow.CancellableFinshedActionPublisher
    public var finish: () -> AppFlow.CancellableFinshedActionPublisher
    public var restart: () -> AppFlow.CancellableFinshedActionPublisher

    public init(
        on _vc: UINavigationController,
        mode: Mode,
        presentationContainerType: UINavigationController.Type,
        delayFinish: Bool = false,
        animateStart: Bool = true
    ) {
        switch mode {
        case .presentation:
            weak var vc = _vc
            let nc = presentationContainerType.init()
            self.nc = nc

            start = { [weak vc] in
                guard let vc = vc else { return AppFlow.cancel() }
                vc.present(nc, animated: animateStart)
                return AppFlow.cancellableFinishedAction
            }

            finish = { [weak vc] in
                guard let vc = vc else { return AppFlow.cancel() }
                vc.dismiss(animated: true)
                let res = delayFinish ? AppFlow.standardPresentationDelay : AppFlow.finishedAction
                return res.addUserCanCancel().eraseType()
            }

            restart = {
                AppFlow.popToRoot(of: nc).addUserCanCancel().eraseType()
            }

        case .inPlace, .embedded:
            assert(_vc.topViewController != nil)
            weak var nc = _vc
            weak var startVC = AppFlow.getStartVC(on: _vc)
            self.nc = _vc

            start = {
                AppFlow.cancellableNoAction
            }

            if mode == .inPlace {
                finish = { [weak startVC] in
                    guard let startVC = startVC else {
                        assertionFailure()
                        return AppFlow.cancellableNoAction
                    }
                    let delayTime = delayFinish ? Styling.standardNavigationDelay : 0
                    return AppFlow.pop(to: startVC, delayFor: delayTime).addUserCanCancel().eraseType()
                }
            }
            else {
                finish = {
                    return AppFlow.cancellableNoAction
                }
            }

            restart = { [weak startVC, weak nc] in
                guard let nc = nc else { return AppFlow.cancel() }
                guard let startVC = startVC else {
                    assertionFailure()
                    return AppFlow.cancel()
                }
                guard let flowFirstVC = AppFlow.vcAfter(startVC, on: nc) else {
                    assertionFailure()
                    return AppFlow.cancel()
                }
                return AppFlow.pop(to: flowFirstVC).addUserCanCancel().eraseType()
            }
        }
    }
}

#endif
