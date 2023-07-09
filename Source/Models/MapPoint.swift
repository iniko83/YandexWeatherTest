//
//  MapPoint.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import CoreLocation

struct MapPoint: Codable {
    let lat: CGFloat
    let lon: CGFloat

    func locationCoordinate() -> CLLocationCoordinate2D {
        .init(
            latitude: lat,
            longitude: lon
        )
    }
}

extension MapPoint: DefaultInitializable {
    init() {
        lat = 55.7522
        lon = 37.6156
    }
}
