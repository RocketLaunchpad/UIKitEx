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

public extension UIViewController {
    class func fromStoryboard<T: UIViewController>(_ storyboardName: String? = nil) -> T {
        let name = storyboardName ?? String(describing: self)
        guard let vc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController() as? T else {
            fatalError("Cannot load from storyboard \(name)")
        }

        return vc
    }

    /// Matches UIViewController.show()
    @objc func hide() {
        if let navigationController = parent as? UINavigationController {
            let all = navigationController.viewControllers
            if let prevVC = zip(all, all.dropFirst()).first(where: { (_, next) in next === self })?.0 {
                (self as? BasicViewController)?.endValue = .fromUI
                navigationController.popToViewController(prevVC, animated: true)
            }
            else if let flowVC = self as? AppFlowViewController {
                flowVC.cancel()
            }
            else {
                navigationController.dismiss(animated: true)
            }
        }
        else if let flowVC = self as? AppFlowViewController {
            flowVC.cancel()
        }
        else {
            (self as? BasicViewController)?.endValue = .fromUI
            dismiss(animated: true)
        }
    }

    func replace(by vc: UIViewController) {
        guard let navigationController = navigationController else {
            fatalError("Expected a valid navigation controller")
        }

        (self as? BasicViewController)?.endValue = .fromCode

        let maybeSnapshotView = view.snapshotView(afterScreenUpdates: true)

        // pop then push doesn't work if there is only one controller
        var viewControllers = navigationController.viewControllers
        viewControllers[viewControllers.count - 1] = vc
        navigationController.viewControllers = viewControllers

        guard let snapshotView = maybeSnapshotView else { return }
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(snapshotView)
        snapshotView.align(to: vc.view).activate()

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                snapshotView.alpha = 0
            },
            completion: { _ in
                snapshotView.removeFromSuperview()
            }
        )
    }

    func isChild(of nc: UINavigationController) -> Bool {
        nc.viewControllers.contains(self)
    }

    func child(of nc: UINavigationController) -> UIViewController? {
        if self === nc {
            return nil
        }
        else if isChild(of: nc) {
            return self
        }
        else {
            return parent?.child(of: nc)
        }
    }
}

#endif
