//
//  UIColor+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import UIKit

extension UIColor {
    final func withAddBrightness(_ value: CGFloat) -> UIColor {
        var hue = CGFloat.zero
        var saturation = CGFloat.zero
        var brightness = CGFloat.zero
        var alpha = CGFloat.zero

        guard
            getHue(
                &hue,
                saturation: &saturation,
                brightness: &brightness,
                alpha: &alpha
            )
        else { return self }

        return .init(
            hue: hue,
            saturation: saturation,
            brightness: (brightness - value).clamped(min: 0, max: 1),
            alpha: alpha
        )
    }
}
