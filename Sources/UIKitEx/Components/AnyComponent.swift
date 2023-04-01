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
import UIKit

public protocol AnyUIKitComponent: UIView {
    associatedtype Style
    var currentStyle: Style? { get set }
    var currentTraits: Styling.Traits? { get set }

    static func style(_ traits: Styling.Traits) -> Style?

    /// Changes styling properties of the view and its subviews.
    /// This method may be called more than once, so if it adds any subviews,
    /// shadows, layers, etc., it should first revert the possible changes
    /// from the previous invocation.
    func applyStyle(_ style: Style)

    /// Changes the constraints according to the style and traits.
    /// This method may be called more than once, so if it adds constraints,
    /// it should first revert the possible changes from the previous invocation.
    func updateLayout(forTraits traits: Styling.Traits, style: Style)

    func overrideCallbacksForStyling()
}

public extension AnyUIKitComponent {
    func updateLayout(forTraits traits: Styling.Traits, style: Style) {}

    private func update(traits: Styling.Traits, style: Style) {
        applyStyle(style)
        updateLayout(forTraits: traits, style: style)
    }

    func update() {
        guard superview != nil else { return }
        if let style = currentStyle, let traits = currentTraits {
            update(traits: traits, style: style)
            return
        }

        let traits: Styling.Traits = .traits(traitCollection)
        update(traits: traits)
    }

    func update(traits: Styling.Traits) {
        guard let style = type(of: self).style(traits) else { return }
        currentTraits = traits
        currentStyle = style
        update(traits: traits, style: style)
    }

    func onDidMoveToSuperview() {
        update()
    }

    func onTraitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        defer { update() }

        guard let previousTraitCollection = previousTraitCollection else {
            return
        }

        let prevTraits: Styling.Traits = .traits(previousTraitCollection)
        let traits: Styling.Traits = .traits(traitCollection)
        if prevTraits != traits {
            currentTraits = traits
            currentStyle = type(of: self).style(traits)
        }
    }
}

#endif
