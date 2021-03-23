//
//  UIImage.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/4/19.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
