//
//  WeatherRequest.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import Foundation

extension Weather {
    enum Request {
        case forecast(Coordinate)

        func apiRequest() -> ApiRequest {
            let result: ApiRequest
            switch self {
            case let .forecast(coordinate):
                result = .init(
                    path: "/forecast",
                    urlQuery: [
                        "lat": coordinate.lat,
                        "lon": coordinate.lon,
                        "lang": Self.forecastLanguageIdentifier,
                        "limit": 7,
                        "hours": true,
                        "extra": false
                    ]
                )
            }
            return result
        }


    }
}

extension Weather.Request {
    static let forecastLanguageIdentifier: String = {
        let isRussian = Locale.current.languageCode == "ru"
        return isRussian
            ? "ru_RU"
            : "en_US"
    }()
}
