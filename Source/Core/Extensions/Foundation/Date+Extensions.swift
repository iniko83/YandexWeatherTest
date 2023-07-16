//
//  Date+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 16.07.2023.
//

import Foundation

extension Date {
    static func currentTimestamp() -> TimeInterval {
        Self().timeIntervalSince1970
    }
}
