//
//  Coordinate.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import CoreLocation

struct Coordinate: Codable {
    let lat: CGFloat
    let lon: CGFloat

    func location() -> CLLocationCoordinate2D {
        .init(
            latitude: lat,
            longitude: lon
        )
    }
}

extension Coordinate: DefaultInitializable {
    init() {
        lat = 55.7522
        lon = 37.6156
    }
}
