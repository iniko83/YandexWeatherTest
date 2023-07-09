//
//  DateFormatter+Utility.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

extension DateFormatter {
    static let weatherForecastDate: DateFormatter = {
        .makeCurrentTimeZone(dateFormat: "yyyy-MM-dd")
    }()

    // MARK: -
    private static func makeCurrentTimeZone(dateFormat: String) -> DateFormatter {
        let result = DateFormatter()
        result.dateFormat = dateFormat
        result.timeZone = .current
        return result
    }
}
