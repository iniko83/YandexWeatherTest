//
//  CAGradientLayer+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 18.07.2023.
//

import UIKit

extension CAGradientLayer {
    static func makeMaskLayer(isVertical: Bool) -> Self {
        let result = Self()
        let colors: [CGColor] = [
            .clear,
            .solid,
            .solid,
            .clear
        ]
        result.colors = colors
        result.locations = [0, 0.1, 0.9, 1]

        if isVertical {
            result.startPoint = .init(x: 0.5, y: 0)
            result.endPoint = .init(x: 0.5, y: 1)
        } else {
            result.startPoint = .init(x: 0, y: 0.5)
            result.endPoint = .init(x: 1, y: 0.5)
        }
        return result
    }

    static func makeHorizontalMaskLayer() -> Self {
        makeMaskLayer(isVertical: false)
    }

    static func makeVerticalMaskLayer() -> Self {
        makeMaskLayer(isVertical: true)
    }
}

extension CAGradientLayer {
    static func makeShimmerLayer() -> Self {
        let result = Self()
        let colors: [CGColor] = [
            .solid,
            .clear,
            .solid
        ]
        result.colors = colors
        result.locations = [0.4, 0.5, 0.6]
        result.startPoint = .init(x: 0, y: 0.4)
        result.endPoint = .init(x: 1, y: 0.6)
        return result
    }
}

extension CAGradientLayer {
    func updateMaskLocations(
        isVertical: Bool,
        bounds: CGRect,
        insets: UIEdgeInsets
    ) {
        let length = isVertical
            ? bounds.height
            : bounds.width
        let factor: CGFloat = length == 0
            ? 0
            : 1 / length

        let beginInset: CGFloat
        let endInset: CGFloat
        if isVertical {
            beginInset = insets.bottom
            endInset = insets.top
        } else {
            beginInset = insets.left
            endInset = insets.right
        }

        let locations: [CGFloat] = [
            0,
            factor * beginInset,
            1 - factor * endInset,
            1
        ]

        self.locations = locations
            .map { value in value.clamped(min: 0, max: 1) as NSNumber }
    }
}

// MARK: - Constants
private extension CGColor {
    static let clear = UIColor.clear.cgColor
    static let solid = UIColor.white.cgColor
}
