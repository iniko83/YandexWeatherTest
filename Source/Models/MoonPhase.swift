//
//  MoonPhase.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

/* Icon example for .phase5: https://yastatic.net/weather/i/moon/05.svg */

enum MoonPhase: Int, Codable {
    case phase0
    case phase1
    case phase2
    case phase3
    case phase4
    case phase5
    case phase6
    case phase7
    case phase8
    case phase9
    case phase10
    case phase11
    case phase12
    case phase13
    case phase14
    case phase15

    func text() -> String {
        let result: String
        switch self {
        case .phase0:
            result = "полнолуние"
        case .phase4:
            result = "последняя четверть"
        case .phase8:
            result = "новолуние"
        case .phase12:
            result = "первая четверть"
        default:
            let isWaning = self < .phase8
            result = isWaning
                ? "убывающая луна"
                : "растущая луна"
        }
        return result
    }
}
