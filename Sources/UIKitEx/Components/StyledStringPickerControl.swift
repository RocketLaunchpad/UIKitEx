//
//  StyledStringPickerControl.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/15/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
//

#if canImport(UIKit)

import UIKit
import Combine
import CombineEx

public extension Styling {
    struct StringPickerControl<F: FontStyling> {
        var rowCircleToTextOffset: CGFloat
        var rowSelectionBorder: View
        var rowSelection: View
        var rowText: Text<F>
        var view: View

        public init(rowCircleToTextOffset: CGFloat, rowSelectionBorder: Styling.View, rowSelection: Styling.View, rowText: Text<F>, view: Styling.View) {
            self.rowCircleToTextOffset = rowCircleToTextOffset
            self.rowSelectionBorder = rowSelectionBorder
            self.rowSelection = rowSelection
            self.rowText = rowText
            self.view = view
        }
    }
}

open class StyledStringPickerControl<F: FontStyling>: UIView, AnyUIKitComponent {
    class RowView: UIView {
        class Label: StyledLabel<F> {
            override var intrinsicContentSize: CGSize {
                var size = super.intrinsicContentSize
                size.height *= 2.0
                return size
            }
        }

        weak var control: StyledStringPickerControl?
        let label = Label()
        let selectionBorderView = CircleView()
        let selectionView = CircleView()

        var isSelected = false {
            didSet {
                applySelectionColor()
            }
        }

        private func applySelectionColor() {
            let selectionColor = UIColor.color(for: currentStyle?.rowSelection.backgroundColor ?? .clear)
            selectionView.backgroundColor = isSelected ? selectionColor : .clear
        }

        init(control: StyledStringPickerControl, text: String) {
            super.init(frame: .zero)

            self.control = control

            selectionBorderView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(selectionBorderView)

            selectionView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(selectionView)

            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            label.text = text

            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateSelection)))
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc private func updateSelection() {
            control?.updateSelection(self)
        }

        // Styling

        typealias Style = Styling.StringPickerControl<F>
        var currentStyle: Style?

        private var layout = Layout()

        func applyStyle(_ style: Style) {
            currentStyle = style
            selectionBorderView.applyStyle(style.rowSelectionBorder)
            selectionView.applyStyle(style.rowSelection)
            label.applyStyle(style.rowText)
            applySelectionColor()
        }

        func updateLayout(forTraits traits: Styling.Traits, style: Style) {
            layout.reset()

            // selectionBorderView
            layout.add(selectionBorderView.alignVerticalCenter(to: self))
            layout.add(selectionBorderView.alignLeftEdge(to: self, insetBy: style.rowCircleToTextOffset))
            layout.add(selectionBorderView.constraintHeight(to: style.rowSelectionBorder.height ?? 0))
            layout.add(selectionBorderView.constraintWidth(to: style.rowSelectionBorder.width ?? 0))

            // selectionView
            layout.add(selectionView.alignCenter(to: selectionBorderView))
            layout.add(selectionView.constraintHeight(to: style.rowSelection.height ?? 0))
            layout.add(selectionView.constraintWidth(to: style.rowSelection.width ?? 0))

            // label
            layout.add(label.alignRightAndSides(to: self))
            layout.add(label.alignLeftEdge(toRightEdgeOf: selectionBorderView, offsetBy: style.rowCircleToTextOffset))

            layout.activate()
        }
    }

    public private(set) var strings: [String] = []
    public var selectionIndex: Int? {
        didSet {
            _selectedString.send(selectionIndex.map { strings[$0] })
        }
    }

    private var _selectedString: PassthroughSubject<String?, Never> = .init()
    public var selectedString: AnyPublisher<String?, Never> {
        _selectedString.eraseToAnyPublisher()
    }

    private var contentView = UIStackView()
    private var layout = Layout()

    public init() {
        super.init(frame: .zero)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.axis = .vertical
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(strings: [String], selectionIndex: Int?) {
        self.strings = strings
        self.selectionIndex = selectionIndex

        for view in contentView.arrangedSubviews {
            view.removeFromSuperview()
        }

        for string in strings {
            let rowView = RowView(control: self, text: string)
            rowView.label.hasBottomSeparator = true
            contentView.addArrangedSubview(rowView)
        }
        (contentView.arrangedSubviews.last as? RowView)?.label.hasBottomSeparator = false

        if let selectionIndex = selectionIndex {
            updateRowView(at: selectionIndex, isSelected: true)
        }

        update()
    }

    private func updateSelection(_ rowView: RowView) {
        guard let index = contentView.arrangedSubviews.firstIndex(of: rowView) else { return }
        if let oldSelectionIndex = selectionIndex {
            updateRowView(at: oldSelectionIndex, isSelected: false)
        }

        if index == selectionIndex {
            selectionIndex = nil
        }
        else {
            updateRowView(at: index, isSelected: true)
            selectionIndex = index
        }
    }

    private func updateRowView(at index: Int, isSelected: Bool) {
        (contentView.arrangedSubviews[index] as? RowView)?.isSelected = isSelected
    }

    // Styling

    public typealias Style = Styling.StringPickerControl<F>
    public var currentStyle: Style?
    public var currentTraits: Styling.Traits?

    open class func style(_ traits: Styling.Traits) -> Style? { nil }

    open func applyStyle(_ style: Style) {
        applyStyle(style.view)

        for case let view as RowView in contentView.arrangedSubviews  {
            view.applyStyle(style)
        }
    }

    open func updateLayout(forTraits traits: Styling.Traits, style: Style) {
        layout.reset()
        layout.add(contentView.align(to: self))
        layout.activate()

        for case let view as RowView in contentView.arrangedSubviews  {
            view.updateLayout(forTraits: traits, style: style)
        }
    }

    // Callbacks for styling

    public func overrideCallbacksForStyling() {}

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        onDidMoveToSuperview()
    }

    public override func traitCollectionDidChange(_ previous: UITraitCollection?) {
        super.traitCollectionDidChange(previous)
        onTraitCollectionDidChange(previous)
    }
}

#endif
