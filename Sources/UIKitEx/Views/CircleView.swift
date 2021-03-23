//
//  CircleView.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 8/29/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public class CircleView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(frame.width, frame.height) / 2.0
    }
}

#endif
