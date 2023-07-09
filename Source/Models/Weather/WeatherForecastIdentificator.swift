//
//  WeatherForecastIdentificator.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

extension Weather.Forecast {
    enum Identificator {
        enum HalfDay: String, CaseIterable, Codable {
            case day    = "day_short"
            case night  = "night_short"
        }

        enum QuarterDay: String, CaseIterable, Codable {
            case night
            case morning
            case day
            case evening
        }

        enum Hour: String, CaseIterable, Codable {
            case hour0  = "0"
            case hour1  = "1"
            case hour2  = "2"
            case hour3  = "3"
            case hour4  = "4"
            case hour5  = "5"
            case hour6  = "6"
            case hour7  = "7"
            case hour8  = "8"
            case hour9  = "9"
            case hour10 = "10"
            case hour11 = "11"
            case hour12 = "12"
            case hour13 = "13"
            case hour14 = "14"
            case hour15 = "15"
            case hour16 = "16"
            case hour17 = "17"
            case hour18 = "18"
            case hour19 = "19"
            case hour20 = "20"
            case hour21 = "21"
            case hour22 = "22"
            case hour23 = "23"
        }
    }
}
