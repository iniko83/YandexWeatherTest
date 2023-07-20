//
//  AppDelegate+Injection.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 07.07.2023.
//

import Resolver

// NOTE: https://github.com/hmlongco/Resolver/blob/master/Documentation/Injection.md#interface

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerInteractors()
    }
}

private extension Resolver {
    static func registerInteractors() {
        register { LocationInteractor.shared as LocationInteractor }
        register { NetworkAvailabilityInteractor() as NetworkAvailabilityInteractor }
        register { SvgImageProviderInteractor.shared as SvgImageProviderInteractor }

        // order mean
        register { WeatherNetworkInteractor() as WeatherNetworkInteractor }
    }
}
