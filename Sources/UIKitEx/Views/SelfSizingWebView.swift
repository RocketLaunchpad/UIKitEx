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
import WebKit

open class SelfSizingWebView: WKWebView {
    private var subscriptions = Set<AnyCancellable>()

    private var height: NSLayoutConstraint?
    private var _finishedLoading = PassthroughSubject<Void, Never>()
    private var updatedHeight = PassthroughSubject<Void, Never>()

    public var openLink: (URL) -> Void = { _ in }

    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        navigationDelegate = self
        self.publisher(for: \.scrollView.contentSize).removeDuplicates().sink { [unowned self] _ in
            assert(Thread.isMainThread)
            self.frame.size.height = 1
            self.evaluateJavaScript("document.body.scrollHeight") { (value, _) in
                let heightJS = (value as? CGFloat) ?? 0
                if let height = self.height {
                    height.constant = heightJS
                }
                else {
                    self.height = self.constraintHeight(to: heightJS).activate()
                }
                self.updatedHeight.send(())
            }
        }
        .store(in: &subscriptions)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func loadHTML(_ html: String) {
        loadHTMLString(html, baseURL: Bundle.main.resourceURL)
    }

    public var finishedLoading: AnyPublisher<Void, Never> {
        _finishedLoading
            .combineLatest(self.updatedHeight)
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}

extension SelfSizingWebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        _finishedLoading.send(())
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        switch navigationAction.navigationType {
        case .linkActivated:
            if let url = navigationAction.request.url {
                openLink(url)
            }
            decisionHandler(.cancel)

        default:
            decisionHandler(.allow)
        }
    }
}

#endif
