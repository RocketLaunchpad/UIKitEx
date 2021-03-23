//
//  UIImageView.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 9/8/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit
import Combine
import CombineEx

public extension UIImageView {
    func getImage(url: URL?) -> AnyCancellable {
        image = nil
        guard let url = url else { return AnyCancellable({}) }
        return UIImage.get(url: url).sink { [weak self] in
            self?.image = $0
//            print("url: \(url), size: \($0?.size ?? .zero)")
        }
    }
}

#endif
