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
    enum Force: String, Codable {
        case zero           = "0"
        case oneQuarter     = "0.25"
        case twoQuarters    = "0.5"
        case threeQuarters  = "0.75"
        case full           = "1"
    }
}
