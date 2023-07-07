//
//  CLLocationManager+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 07.07.2023.
//

import CoreLocation

extension CLLocationManager {
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        let result: CLAuthorizationStatus
        if #available(iOS 15, *) {
            result = authorizationStatus
        } else {
            result = Self.authorizationStatus()
        }
        return result
    }
}
