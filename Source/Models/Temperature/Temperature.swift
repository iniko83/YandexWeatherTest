//
//  Temperature.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

/* NOTE: - Вариант для date_short будем трактовать как value. */
enum Temperature: Equatable {
    case value(Int)
    case detailed(average: Int, minimum: Int, maximum: Int)
}

extension Temperature: Codable {
    private enum CodingKeys: String, CodingKey {
        case minimum = "temp_min"
        case maximum = "temp_max"
        case average = "temp_avg"
        case value = "temp"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if
            let average = try container.decodeIfPresent(Int.self, forKey: .maximum),
            let minimum = try container.decodeIfPresent(Int.self, forKey: .minimum),
            let maximum = try container.decodeIfPresent(Int.self, forKey: .maximum)
        {
            self = .detailed(
                average: average,
                minimum: minimum,
                maximum: maximum
            )
        } else {
            let value = try container.decode(Int.self, forKey: .value)
            self = .value(value)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .detailed(average, minimum, maximum):
            try container.encode(average, forKey: .average)
            try container.encode(minimum, forKey: .minimum)
            try container.encode(maximum, forKey: .maximum)

        case let .value(value):
            try container.encode(value, forKey: .value)
        }
    }
}

extension Temperature: DefaultInitializable {
    init() {
        self = .value(.zero)
    }
}
