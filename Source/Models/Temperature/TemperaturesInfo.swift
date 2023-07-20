//
//  TemperaturesInfo.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

struct TemperaturesInfo: Equatable {
    let temperature: Temperature    // Температура, °C
    let feelsLike: Int              // Ощущаемая температура, °C

    func feelsLikeString() -> String {
        celciusString(feelsLike)
    }

    func currentTemperatureString() -> String {
        let result: String
        switch temperature {
        case let .value(value), let .detailed(value, _, _):
            result = celciusString(value)
        }
        return result
    }

    func temperatureString(separator: String = .endline) -> String {
        let result: String
        switch temperature {
        case let .value(value):
            result = celciusString(value)
        case let .detailed(_, minimum, maximum):
            result = celciusString(minimum)
                + separator
                + celciusString(maximum)
        }
        return result
    }

    private func celciusString(_ value: Int) -> String {
        let string = "\(value)°"
        return value > 0
            ? "+" + string
            : string
    }
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

extension TemperaturesInfo: DefaultInitializable {
    init() {
        self.init(
            temperature: .init(),
            feelsLike: .zero
        )
    }
}

// MARK: - Constants
private extension String {
    static let endline = "\n"
}
