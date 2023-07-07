//
//  CLAuthorizationStatus+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 07.07.2023.
//

import CoreLocation

extension CLAuthorizationStatus {
    func isAuthorized() -> Bool {
        let result: Bool
        switch self {
        case .authorizedAlways, .authorizedWhenInUse:
            result = true
        default:
            result = false
        }
        return result
    }

    func isDenied() -> Bool {
        let result: Bool
        switch self {
        case .denied, .restricted:
            result = true
        default:
            result = false
        }
        return result
    }

    func isNotDetermined() -> Bool {
        self == .notDetermined
    }
}
