//
//  CAGradientLayer+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 18.07.2023.
//

import UIKit

extension CAGradientLayer {
    static func makeShimmerLayer() -> Self {
        let result = Self()

        let solidColor = UIColor.white.cgColor
        let transparentColor = UIColor.clear.cgColor

        result.colors = [
            solidColor,
            transparentColor,
            solidColor
        ]
        result.locations = [0.4, 0.5, 0.6]
        result.startPoint = .init(x: 0.0, y: 0.4)
        result.endPoint = .init(x: 1.0, y: 0.6)

        return result
    }
}
