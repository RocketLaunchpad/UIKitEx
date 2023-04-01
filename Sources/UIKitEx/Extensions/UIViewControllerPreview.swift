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
