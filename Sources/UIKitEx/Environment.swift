//
//  Environment.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 03/30/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public enum UIKitEx {
    public struct Environment {
        public var urlDataPublisher = URLDataPublisher.default
        public var vcViewClass: UIView.Type = UIView.self
    }

    public static var env = Environment()
}

#endif
