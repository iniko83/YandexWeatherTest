//
//  SunAppearance.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

/* Время окончания восхода/ начала заката Солнца, локальное время (может отсутствовать для полярных регионов). В формате "hh:mm". */
struct SunAppearance: Codable, Equatable {
    let sunrise: String?
    let sunset: String?
}

extension SunAppearance: DefaultInitializable {
    init() {
        self.init(
            sunrise: nil,
            sunset: nil
        )
    }
}
