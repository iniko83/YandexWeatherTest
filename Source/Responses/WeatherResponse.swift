//
//  WeatherResponse.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

extension Weather {
    struct Response {
        let fact: Fact
        let forecasts: [Forecast]
        let locality: Locality
        let timestamp: Date
    }
}

extension Weather.Response: Codable {
    private enum CodingKeys: String, CodingKey {
        case timestamp  = "now"
        case fact
        case forecasts
    }

    init(from decoder: Decoder) throws {
        locality = try .init(from: decoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        fact = try container.decode(Weather.Fact.self, forKey: .fact)
        forecasts = try container.decode([Weather.Forecast].self, forKey: .forecasts)

        let timestampValue = try container.decode(Int.self, forKey: .timestamp)
        timestamp = .init(timeIntervalSince1970: TimeInterval(timestampValue))
    }

    func encode(to encoder: Encoder) throws {
        try locality.encode(to: encoder)

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(fact, forKey: .fact)
        try container.encode(forecasts, forKey: .forecasts)

        let timestampValue = Int(timestamp.timeIntervalSince1970)
        try container.encode(timestampValue, forKey: .timestamp)
    }
}
