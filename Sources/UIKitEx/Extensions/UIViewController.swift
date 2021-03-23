//
//  UIViewController.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 6/22/17.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
