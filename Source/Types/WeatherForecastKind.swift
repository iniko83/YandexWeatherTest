//
//  WeatherForecastKind.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import Foundation

extension Weather.Forecast {
    enum Kind: Int, CaseIterable {
        case dayHalfs
        case dayQuarters
        case hours

        init(index: Int) {
            switch index {
            case 1:
                self = .dayQuarters
            case 2:
                self = .hours
            default:
                self = .dayHalfs
            }
        }

        func title() -> String {
            let result: String
            switch self {
            case .dayHalfs:
                result = L10n.Weather.Forecast.Kind.dayHalfs
            case .dayQuarters:
                result = L10n.Weather.Forecast.Kind.dayQuarters
            case .hours:
                result = L10n.Weather.Forecast.Kind.hours
            }
            return result
        }
    }
}

extension Weather.Forecast.Kind: DefaultInitializable {
    init() {
        self = .dayHalfs
    }
}
