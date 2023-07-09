//
//  Locality.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

struct Locality {
    let coordinate: Coordinate
    let name: String
}

extension Locality: Codable {
    private enum CodingKeys: String, CodingKey {
        case coordinate = "info"
        case geoObject  = "geo_object"
    }

    private enum GeoObjectKeys: String, CodingKey {
        case locality
    }

    private enum LocalityKeys: String, CodingKey {
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)

        let localityContainer = try container
            .nestedContainer(keyedBy: GeoObjectKeys.self, forKey: .geoObject)
            .nestedContainer(keyedBy: LocalityKeys.self, forKey: .locality)
        name = try localityContainer.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate, forKey: .coordinate)

        var geoObjectContainer = container
            .superEncoder(forKey: .geoObject)
            .container(keyedBy: GeoObjectKeys.self)
        var localityContainer = geoObjectContainer
            .superEncoder(forKey: .locality)
            .container(keyedBy: LocalityKeys.self)
        try localityContainer.encodeIfPresent(name, forKey: .name)
    }
}
