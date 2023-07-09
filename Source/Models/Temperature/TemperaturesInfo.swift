//
//  TemperaturesInfo.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

struct TemperaturesInfo {
    let temperature: Temperature    // Температура, °C
    let feelsLike: Int              // Ощущаемая температура, °C
}

extension TemperaturesInfo: Codable {
    private enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
    }

    init(from decoder: Decoder) throws {
        temperature = try .init(from: decoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        feelsLike = try container.decode(Int.self, forKey: .feelsLike)
    }

    func encode(to encoder: Encoder) throws {
        try temperature.encode(to: encoder)

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(feelsLike, forKey: .feelsLike)
    }
}
