//
//  Array+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        indices ~= index
            ? self[index]
            : nil
    }
}
