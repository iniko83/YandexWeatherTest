//
//  CLLocationManager+RxExtensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 07.07.2023.
//

import CoreLocation
import RxSwift

extension CLLocationManager {
    func isAuthorizedObservable() -> Observable<Bool> {
        rx
            .didChangeAuthorizationStatus
            .startWith(getAuthorizationStatus())
            .map { status in status.isAuthorized() }
    }

    func authorizeWhenInUse() -> Single<Bool> {
        let authorizationStatus = getAuthorizationStatus()

        guard authorizationStatus.isNotDetermined() else {
            let isAuthorized = authorizationStatus.isAuthorized()
            return .just(isAuthorized)
        }

        let result = rx
            .didChangeAuthorizationStatus
            .map { status in status.isAuthorized() }
            .asSingle()

        requestWhenInUseAuthorization()

        return result
    }

    func requestLocation() -> Single<CLLocationCoordinate2D> {
        authorizeWhenInUse()
            .asObservable()
            .flatMap { isAuthorized in
                Observable<LocationResult>
                    .merge(
                        self.rx
                            .didUpdateLocation
                            .compactMap { locations in locations.first?.coordinate }
                            .map { coordinate in .coordinate(coordinate) },
                        self.rx
                            .didFailWithError
                            .map { error in .error(error) }
                    )
                    .map { locationResult in try locationResult.tryGetCoordinate() }
            }
            .asSingle()
    }
}

// MARK: - Helpers
private enum LocationResult {
    case coordinate(CLLocationCoordinate2D)
    case error(Error)

    func tryGetCoordinate() throws -> CLLocationCoordinate2D {
        let result: CLLocationCoordinate2D
        switch self {
        case let .coordinate(value):
            result = value
        case let .error(error):
            throw error
        }
        return result
    }
}
