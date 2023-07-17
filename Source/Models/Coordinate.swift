//
//  Coordinate.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import CoreLocation

extension Coordinate {
    static let `default` = Self(lat: 55.7522, lon: 37.6156)
}

struct Coordinate: Codable, Equatable {
    let lat: CGFloat
    let lon: CGFloat

    func locationCoordinate() -> CLLocationCoordinate2D {
        .init(
            latitude: lat,
            longitude: lon
        )
    }
}

extension Coordinate {
    init(locationCoordinate: CLLocationCoordinate2D) {
        self.init(
            lat: locationCoordinate.latitude,
            lon: locationCoordinate.longitude
        )
    }
}
