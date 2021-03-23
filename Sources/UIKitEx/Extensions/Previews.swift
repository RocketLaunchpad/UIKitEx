//
//  Previews.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 12/21/19.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit
import SwiftUI

public enum AppPreviews {
    public static var devices = [
        "iPhone 11",
        "iPad (6th generation)"
    ]

    @ViewBuilder
    public static func all<ViewController: UIViewController>(_ builder: @escaping () -> ViewController) -> some View {
        ForEach(devices, id: \.self) { device in
            UIViewControllerPreview(builder)
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }
    }

    public static func all<ContentView: UIView>(_ builder: @escaping () -> ContentView) -> some View {
        ForEach(devices, id: \.self) { device in
            UIViewPreview(builder)
            .padding(20)
            .background(Color.init(white: 0.9))
            .previewDevice(PreviewDevice(rawValue: device))
            .previewDisplayName(device)
        }
    }
}

public struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    public init(_ builder: () -> View) {
        view = builder()
    }

    // MARK: - UIViewRepresentable

    public func makeUIView(context: Context) -> UIView {
        return view
    }

    public func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

public struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    public init(_ builder: () -> ViewController) {
        viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable
    public func makeUIViewController(context: Context) -> ViewController {
        viewController
    }

    public func updateUIViewController(
        _ vc: ViewController,
        context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>
    ) {
        return
    }
}

#endif
