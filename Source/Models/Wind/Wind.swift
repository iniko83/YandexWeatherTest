//
//  Wind.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

struct Wind {
    let direction: Direction    // Направление
    let speed: CGFloat          // Скорость, м/с
}

extension Wind: Codable {
    private enum CodingKeys: String, CodingKey {
        case direction  = "wind_dir"
        case speed      = "wind_speed"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        direction = try container.decode(Direction.self, forKey: .direction)
        speed = try container.decode(CGFloat.self, forKey: .speed)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(direction, forKey: .direction)
        try container.encode(speed, forKey: .speed)
    }
}
