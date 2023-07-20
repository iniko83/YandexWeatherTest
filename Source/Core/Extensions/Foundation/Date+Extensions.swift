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

extension Date {
    func forecastShortTitleString() -> String {
        todayOrTomorrowString()
            ?? DateFormatter.weatherForecastShortTitle.string(from: self)
    }

    func forecastTitleString() -> String {
        todayOrTomorrowString()
            ?? DateFormatter.weatherForecastTitle.string(from: self)
    }

    private func todayOrTomorrowString() -> String? {
        let calendar = Calendar.current

        let result: String?
        if calendar.isDateInToday(self) {
            result = L10n.Text.today
        } else if calendar.isDateInTomorrow(self) {
            result = L10n.Text.tomorrow
        } else {
            result = nil
        }
        return result
    }
}
