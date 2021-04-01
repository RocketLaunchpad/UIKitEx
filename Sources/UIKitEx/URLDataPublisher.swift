//
//  URLDataPublisher.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 6/17/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

import Foundation
import Combine
import CombineEx

public struct URLDataPublisher {
    public init(data: @escaping (URLRequest) -> URLDataPublisher.Publisher) {
        self.data = data
    }

    public typealias Publisher = AnySingleValuePublisher<(data: Data, response: URLResponse), URLError>
    var data: (_ request: URLRequest) -> Publisher

    public func callAsFunction(for request: URLRequest) -> Publisher {
        data(request)
    }
}

public extension URLDataPublisher {
    static let `default` = URLDataPublisher { request in
        URLSession.shared.dataTaskPublisher(for: request).eraseType()
    }
}
