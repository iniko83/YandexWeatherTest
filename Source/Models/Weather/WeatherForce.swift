//
//  WeatherForce.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

/*
 prec_strength:
 0 — без осадков.
 0.25 — слабый дождь/слабый снег.
 0.5 — дождь/снег.
 0.75 — сильный дождь/сильный снег.
 1 — сильный ливень/очень сильный снег.

 cloudness
 0 — ясно.
 0.25 — малооблачно.
 0.5 — облачно с прояснениями.
 0.75 — облачно с прояснениями.
 1 — пасмурно.
 */

extension Weather {
    enum Force: Int, Equatable {
        case zero
        case oneQuarter
        case twoQuarters
        case threeQuarters
        case full
    }
}

extension Weather.Force: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedValue = try container.decode(Float.self)

        guard let value = Self(float: decodedValue) else {
            let message = "Failed to decode \(String(describing: Self.self))"
            let error = DecodingError.dataCorruptedError(
                in: container,
                debugDescription: message
            )
            throw error
        }

        self = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(floatValue())
    }
}

private extension Weather.Force {
    init?(float: Float) {
        let rawValue = Int(float * 4)
        self.init(rawValue: rawValue)
    }

    func floatValue() -> Float {
        let result: Float
        switch self {
        case .zero:
            result = 0
        case .oneQuarter:
            result = 0.25
        case .twoQuarters:
            result = 0.5
        case .threeQuarters:
            result = 0.75
        case .full:
            result = 1
        }
        return result
    }
}
