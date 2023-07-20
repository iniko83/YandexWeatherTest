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

    static let weatherForecastShortTitle: DateFormatter = {
        .makeCurrentTimeZone(dateFormat: "dd MMM")
    }()

    static let weatherForecastTitle: DateFormatter = {
        .makeCurrentTimeZone(dateFormat: "EEEE, dd MMMM")
    }()

    // MARK: -
    private static func makeCurrentTimeZone(dateFormat: String) -> DateFormatter {
        let result = DateFormatter()
        result.dateFormat = dateFormat
        result.timeZone = .current
        return result
    }
}
