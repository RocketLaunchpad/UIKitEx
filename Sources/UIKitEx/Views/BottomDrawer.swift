//
//  BottomDrawerView.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 11/12/20.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit

open class BottomDrawer<T: UIView>: FloatingCard<T> {
    private var handle: UIView?
    private var handleContainerView: UIView?
    private var closeButton: UIButton?

    private var closeAction: (() -> Void)?

    @objc private func close(_ sender: Any) {
        closeAction?()
    }

    public init(
        _ contentView: T,
        showHandle: Bool = false,
        closeAction: (() -> Void)? = nil,
        styleFunc: @escaping (Styling.Traits) -> Styling.FloatingCard
    ) {
        self.closeAction = closeAction
        super.init(contentView, styleFunc: styleFunc)

        let handleSize = CGSize(width: 40, height: 5)
        if showHandle {
            let handleContainerView = PassthroughView()
            self.handleContainerView = handleContainerView
            handleContainerView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(handleContainerView)

            let handle = UIView()
            self.handle = handle
            handle.translatesAutoresizingMaskIntoConstraints = false
            handleContainerView.addSubview(handle)
            handle.layer.backgroundColor = UIColor(white: 0, alpha: 0.2).cgColor
            handle.layer.cornerRadius = handleSize.height / 2
        }

        if closeAction != nil {
            let closeButton = UIButton()
            self.closeButton = closeButton
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            addSubview(closeButton)
            let closeImage = UIImage(systemName: "xmark.circle.fill")
            closeButton.setImage(closeImage, for: .normal)
            closeButton.tintColor = .lightGray
            closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        }

        var layout = Layout()

        // handle
        if let handle = handle, let handleContainerView = handleContainerView {
            layout.add(handleContainerView.alignTopAndSides(to: self))
            layout.add(handleContainerView.constraintHeight(to: 44))

            layout.add(handle.constraintWidth(to: handleSize.width))
            layout.add(handle.constraintHeight(to: handleSize.height))
            layout.add(handle.alignTopEdge(to: handleContainerView, insetBy: 5))
            layout.add(handle.alignHorizontalCenter(to: handleContainerView))
        }

        // closeButton
        if let closeButton = closeButton {
            layout.add(closeButton.alignRightEdge(to: self, insetBy: 0))
            layout.add(closeButton.alignTopEdge(to: self, insetBy: 0))
            layout.add(closeButton.constraintWidth(to: 40))
            layout.add(closeButton.constraintHeight(to: 40))
        }

        layout.activate()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class ResizableBottomDrawer<V: ResizableContentView>: BottomDrawer<ResizableView<V>>, UIGestureRecognizerDelegate {
    private var panGestureRecognizer: UIPanGestureRecognizer!

    public typealias ContentView = V

    public init(
        _ cardContentView: ContentView,
        showHandle: Bool = true,
        closeAction: (() -> Void)? = nil,
        styleFunc: @escaping (Styling.Traits) -> Styling.FloatingCard
    ) {
        super.init(
            ResizableView(cardContentView, fixedEdge: .bottom),
            showHandle: showHandle,
            closeAction: closeAction,
            styleFunc: styleFunc
        )

        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleDrag(_:))
        )
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func handleDrag(_ gr: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        contentView.handleDrag(gr, in: superview)
    }

    // MARK: - UIGestureRecognizerDelegate

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer)
    -> Bool
    {
        return gestureRecognizer == panGestureRecognizer
    }
}

#endif
