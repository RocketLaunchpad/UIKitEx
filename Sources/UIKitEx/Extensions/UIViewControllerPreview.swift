//
//  UIViewControllerPreview.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 7/14/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit
import SwiftUI

struct ViewController_Preview: PreviewProvider {
    private class ReplacedVC: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()

            view.backgroundColor = .lightGray

            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            label.text = "Replaced Content"

            label.alignCenter(to: view).activate()
        }
    }

    private class StartVC: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()

            view.backgroundColor = .white

            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            button.setTitle("Repace Content", for: .normal)
            button.addTarget(self, action: #selector(replace(_:)), for: .touchUpInside)

            button.alignCenter(to: view).activate()
        }

        @objc func replace(_ sender: Any) {
            replace(by: ReplacedVC())
        }
    }

    static var previews: some View {
        UIViewControllerPreview {
            UINavigationController(rootViewController: StartVC())
        }
    }
}

#endif
