//
//  MoonPhase.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

/* Icon example for .phase5: https://yastatic.net/weather/i/moon/05.svg */

enum MoonPhase: Int, Codable, Equatable {
    case phase0     // full moon
    case phase1     // waning moon
    case phase2
    case phase3
    case phase4     // last quarter
    case phase5     // waning moon
    case phase6
    case phase7
    case phase8     // new moon
    case phase9     // waxing crescent
    case phase10
    case phase11
    case phase12    // first quarter
    case phase13    // waxing crescent
    case phase14
    case phase15

    func text() -> String {
        let result: String
        switch self {
        case .phase0:
            result = L10n.MoonPhase.Text.fullMoon
        case .phase4:
            result = L10n.MoonPhase.Text.lastQuarter
        case .phase8:
            result = L10n.MoonPhase.Text.newMoon
        case .phase12:
            result = L10n.MoonPhase.Text.firstQuarter
        default:
            result = self < .phase8
                ? L10n.MoonPhase.Text.waningMoon
                : L10n.MoonPhase.Text.waxingCrescent
        }
        return result
    }
}

extension MoonPhase: DefaultInitializable {
    init() {
        self = .phase0
    }
}
