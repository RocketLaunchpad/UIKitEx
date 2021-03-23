//
//  UITextField.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 7/12/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

extension UITextField: TextControl {
    public var textValue: String? {
        get { text }
        set { text = newValue }
    }
}

#endif
