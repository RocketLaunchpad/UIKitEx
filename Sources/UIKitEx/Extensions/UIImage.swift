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

import FoundationEx
import UIKit
import Combine
import CombineEx

public extension UIImage {
    func scaled(by scale: Int, screenScale: CGFloat = 1) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width * CGFloat(scale), height: size.height * CGFloat(scale))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, screenScale)
        draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("Expected a valid image when scaling")
        }
        UIGraphicsEndImageContext()
        return newImage
    }
}

public extension UIImage {
    private static var cache = Cache<URL, UIImage?>()
    private static var tasks: [URL: AnySingleValuePublisher<UIImage?, Never>] = [:]

    private static func get(url: URL, completion: @escaping (UIImage?) -> Void) {
        assert(Thread.isMainThread)

        if let image = cache[url] {
            completion(image)
            return
        }

        var task: AnySingleValuePublisher<UIImage?, Never>
        if let dictTask = tasks[url] {
            task = dictTask
        }
        else {
            let request = URLRequest(url: url)
            task = UIKitEx.env.urlDataPublisher(for: request)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .share()
                .eraseType()
            tasks[url] = task
        }

        task.sideEffect { value in
            cache[url] = value
            tasks.removeValue(forKey: url)
            completion(value)
        }
        .map { _ in }
        .runAsSideEffect()
    }

    static func get(url: URL?) -> LazyFuture<UIImage?, Never> {
        guard let url = url else {
            return LazyFuture { $0(.success(nil)) }
        }

        return LazyFuture { promise in
            get(url: url, completion: { promise(.success($0)) })
        }
    }

    static func clearCache() {
        cache.removeAll()
    }
}

#endif
