//
//  WeatherForecast.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

extension Weather.Forecast {
    typealias BaseInfo = Weather.BaseInfo
}

extension Weather {
    struct Forecast: Equatable {
        let date: Date
        let moonPhase: MoonPhase
        let sunAppearance: SunAppearance

        let halfDays: [Identificator.HalfDay: BaseInfo]
        let quarterDays: [Identificator.QuarterDay: BaseInfo]
        let hours: [Identificator.Hour: BaseInfo]

        func baseInfo(id: Identificator) -> BaseInfo? {
            let result: BaseInfo?
            switch id {
            case let .halfDay(id):
                result = halfDays[id]
            case let .quarterDay(id):
                result = quarterDays[id]
            case let .hour(id):
                result = hours[id]
            }
            return result
        }

        func identificators(kind: Kind) -> [Identificator] {
            let result: [Identificator]
            switch kind {
            case .dayHalfs:
                let ids = Set(halfDays.keys)
                result = Identificator.HalfDay
                    .allCases
                    .compactMap { id in ids.contains(id) ? .halfDay(id) : nil }

            case .dayQuarters:
                let ids = Set(quarterDays.keys)
                result = Identificator.QuarterDay
                    .allCases
                    .compactMap { id in ids.contains(id) ? .quarterDay(id) : nil }

            case .hours:
                let ids = Set(hours.keys)
                result = Identificator.Hour
                    .allCases
                    .compactMap { id in ids.contains(id) ? .hour(id) : nil }
            }
            return result
        }
    }
}

extension Weather.Forecast: Codable {
    private enum CodingKeys: String, CodingKey {
        case dateString = "date"
        case moonPhase  = "moon_code"
        case parts
        case hours
    }

    init(from decoder: Decoder) throws {
        sunAppearance = try .init(from: decoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        moonPhase = try container.decode(MoonPhase.self, forKey: .moonPhase)

        date = try Self.decodeDate(from: container)
        hours = try Self.decodeHours(from: container)

        let parts = try container.decode(Parts.self, forKey: .parts)
        halfDays = parts.halfDays
        quarterDays = parts.quarterDays
    }

    func encode(to encoder: Encoder) throws {
        try sunAppearance.encode(to: encoder)

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(moonPhase, forKey: .moonPhase)

        try container.encode(makeDateString(), forKey: .dateString)
        try container.encode(makeEncodableHours(), forKey: .hours)
        try container.encode(makeParts(), forKey: .parts)
    }

    // MARK: -
    private static func decodeDate(
        from container: KeyedDecodingContainer<CodingKeys>
    ) throws -> Date {
        let dateString = try container.decode(String.self, forKey: .dateString)
        let dateFormatter = self.dateFormatter()

        guard let result = dateFormatter.date(from: dateString) else {
            let expected = dateFormatter.dateFormat!
            let description = "Wrong date string format (expected: \"\(expected)\")"
            let error = DecodingError.dataCorruptedError(
                forKey: .dateString,
                in: container,
                debugDescription: description
            )

            throw error
        }

        return result
    }

    private static func decodeHours(
        from container: KeyedDecodingContainer<CodingKeys>
    ) throws -> [Identificator.Hour: BaseInfo] {
        let hours = try container.decode([Weather.HourBaseInfo].self, forKey: .hours)
        return hours.reduce(
            into: [Identificator.Hour: BaseInfo](),
            { result, value in
                result[value.id] = value.baseInfo
            }
        )
    }

    private static func dateFormatter() -> DateFormatter {
        .weatherForecastDate
    }

    private func makeDateString() -> String {
        Self.dateFormatter().string(from: date)
    }

    private func makeEncodableHours() -> [Weather.HourBaseInfo] {
        hours
            .map { (id, value) in
                .init(
                    id: id,
                    baseInfo: value
                )
            }
    }

    private func makeParts() -> Parts {
        .init(
            halfDays: halfDays,
            quarterDays: quarterDays
        )
    }
}

extension Weather.Forecast: DefaultInitializable {
    init() {
        self.init(
            date: .init(),
            moonPhase: .init(),
            sunAppearance: .init(),
            halfDays: .init(),
            quarterDays: .init(),
            hours: .init()
        )
    }
}

// MARK: - Private Helpers
private extension Weather.HourBaseInfo {
    typealias Identificator = Weather.Forecast.Identificator.Hour
}

private extension Weather {
    struct HourBaseInfo: Codable {
        let id: Identificator
        let baseInfo: BaseInfo

        init(
            id: Identificator,
            baseInfo: BaseInfo
        ) {
            self.id = id
            self.baseInfo = baseInfo
        }

        // MARK: - Codable
        private enum CodingKeys: String, CodingKey {
            case id = "hour"
        }

        init(from decoder: Decoder) throws {
            baseInfo = try .init(from: decoder)

            let container = try decoder.container(keyedBy: CodingKeys.self)

            id = try container.decode(Identificator.self, forKey: .id)
        }

        func encode(to encoder: Encoder) throws {
            try baseInfo.encode(to: encoder)

            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(id, forKey: .id)
        }
    }
}


private extension Weather.Forecast {
    struct Parts: Codable {
        let halfDays: [Identificator.HalfDay: BaseInfo]
        let quarterDays: [Identificator.QuarterDay: BaseInfo]

        init(
            halfDays: [Identificator.HalfDay: BaseInfo],
            quarterDays: [Identificator.QuarterDay: BaseInfo]
        ) {
            self.halfDays = halfDays
            self.quarterDays = quarterDays
        }

        // MARK: - Codable
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let dictionary = try container.decode([String: BaseInfo].self)

            halfDays = dictionary
                .reduce(
                    into: .init(),
                    { result, element in
                        let (string, value) = element
                        guard let id = Identificator.HalfDay(rawValue: string) else { return }
                        result[id] = value
                    }
                )

            quarterDays = dictionary
                .reduce(
                    into: .init(),
                    { result, element in
                        let (string, value) = element
                        guard let id = Identificator.QuarterDay(rawValue: string) else { return }
                        result[id] = value
                    }
                )
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            var dictionary = [String: BaseInfo]()
            for (id, value) in halfDays {
                dictionary[id.rawValue] = value
            }
            for (id, value) in quarterDays {
                dictionary[id.rawValue] = value
            }

            try container.encode(dictionary)
        }
    }
}
