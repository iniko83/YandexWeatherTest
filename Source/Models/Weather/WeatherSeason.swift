//
//  WeatherSeason.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

extension Weather {
    enum Season: String, Codable, Equatable {
        case summer // лето
        case autumn // осень
        case winter // зима
        case spring // весна
    }
}
