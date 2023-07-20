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
            .take(1)
            .asSingle()

        requestWhenInUseAuthorization()

        return result
    }

    func requestLocation() -> Single<CLLocationCoordinate2D> {
        authorizeWhenInUse()
            .flatMap { isAuthorized in
                let result: Single<CLLocationCoordinate2D>
                if isAuthorized {
                    if let coordinate = self.location?.coordinate {
                        result = .just(coordinate)
                    } else {
                        result = Observable<CLLocationCoordinate2D>
                            .merge(
                                self.rx
                                    .didUpdateLocation
                                    .compactMap { locations in locations.first?.coordinate },
                                self.rx
                                    .didFailWithError
                                    .map { error in throw error }
                            )
                            .take(1)
                            .asSingle()
                    }
                } else {
                    let error = CLError(.denied)
                    result = .error(error)
                }
                return result
            }
    }
}
