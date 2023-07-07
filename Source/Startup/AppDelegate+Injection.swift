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
        register { PreferenceInteractor() as PreferenceInteractor }
    }
}
