//
//  WeatherCoordinate.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 17.07.2023.
//

import CoreLocation

extension WeatherCoordinate {
    static let `default` = Self(coordinate: .default, isDefault: true)
}

struct WeatherCoordinate: Equatable {
    let coordinate: Coordinate
    let isDefault: Bool
}

extension WeatherCoordinate {
    init(locationCoordinate: CLLocationCoordinate2D) {
        self.init(
            coordinate: .init(locationCoordinate: locationCoordinate),
            isDefault: false
        )
    }
}
