//
//  WeatherBaseInfo.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

/* Базовая информация, отображаемая в ячейках.
    condition           // Погодные условия
    conditionIconAlias  // Иконка погодных условий
    pressure            // Давление (мм рт. ст.)
    humidity            // Влажность воздуха (%)

 Иконка погодных условий доступна по адресу:
    https://yastatic.net/weather/i/icons/funky/dark/\(conditionIconAlias).svg
 **/

extension Weather {
    struct BaseInfo: Equatable {
        let temperaturesInfo: TemperaturesInfo
        let wind: Wind

        let condition: Condition
        let conditionIconAlias: String
        let pressure: Int
        let humidity: Int

        func humidityString() -> String {
            "\(humidity)%"
        }

        func pressureString() -> String {
            .init(pressure)
        }
    }
}

extension Weather.BaseInfo: Codable {
    private enum CodingKeys: String, CodingKey {
        case condition
        case conditionIconAlias = "icon"
        case pressure           = "pressure_mm"
        case humidity
    }

    init(from decoder: Decoder) throws {
        temperaturesInfo = try .init(from: decoder)
        wind = try .init(from: decoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        condition = try container.decode(Weather.Condition.self, forKey: .condition)
        conditionIconAlias = try container.decode(String.self, forKey: .conditionIconAlias)
        pressure = try container.decode(Int.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
    }

    func encode(to encoder: Encoder) throws {
        try temperaturesInfo.encode(to: encoder)
        try wind.encode(to: encoder)

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(conditionIconAlias, forKey: .conditionIconAlias)
        try container.encode(condition, forKey: .condition)
        try container.encode(pressure, forKey: .pressure)
        try container.encode(humidity, forKey: .humidity)
    }
}

extension Weather.BaseInfo: DefaultInitializable {
    init() {
        self.init(
            temperaturesInfo: .init(),
            wind: .init(),
            condition: .init(),
            conditionIconAlias: .init(),
            pressure: .zero,
            humidity: .zero
        )
    }
}
