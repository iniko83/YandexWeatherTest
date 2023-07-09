//
//  Daytime.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

struct Daytime {
    let isDay: Bool
    let isPolar: Bool
}

extension Daytime: Codable {
    private enum CodingKeys: String, CodingKey {
        case timeOfDay = "daytime"
        case isPolar = "polar"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        isPolar = try container.decode(Bool.self, forKey: .isPolar)

        let timeOfDay = try container.decode(TimeOfDay.self, forKey: .timeOfDay)
        isDay = timeOfDay.isDay()
    }

    func encode(to encoder: Encoder) throws {
        let timeOfDay = TimeOfDay(isDay: isDay)

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(timeOfDay, forKey: .timeOfDay)
        try container.encode(isPolar, forKey: .isPolar)
    }
}

// MARK: - Private helpers
private enum TimeOfDay: String, Codable {
    case day    = "d"   // светлое время суток
    case night  = "n"   // темное время суток

    init(isDay: Bool) {
        self = isDay ? .day : .night
    }

    func isDay() -> Bool {
        self == .day
    }
}
