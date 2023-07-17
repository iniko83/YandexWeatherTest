//
//  WeatherView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import Foundation

protocol WeatherView {
    func showLocationDeniedAlert()

    func updateLocationAvailabilityStatus(isShowing: Bool)
    func updateNetworkAvailabilityStatus(isShowing: Bool)
}
