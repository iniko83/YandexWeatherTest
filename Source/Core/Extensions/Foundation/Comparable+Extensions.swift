//
//  Comparable+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 11.07.2023.
//

import Foundation

extension Comparable {
    func clamped(min: Self, max: Self) -> Self {
        self < min
            ? min
            : self > max
                ? max
                : self
    }
}
