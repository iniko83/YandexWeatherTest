//
//  LocationInteractor.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 07.07.2023.
//

import CoreLocation
import RxRelay
import RxSwift

/* Пример интерактора c RxSwift */

protocol LocationInteractorInterface: AnyObject {
    var isAuthorized: BehaviorRelay<Bool> { get }
    var isDenied: BehaviorRelay<Bool> { get }

    func requestLocation() -> Single<CLLocationCoordinate2D>
}

final class LocationInteractor {
    private let bag = DisposeBag()

    private let locationManager = CLLocationManager()

    // LocationInteractorInterface
    let isAuthorized = BehaviorRelay<Bool>()
    let isDenied = BehaviorRelay<Bool>()

    init() {
        bindAuthStatusRelays()
    }

    private func bindAuthStatusRelays() {
        let authStatus = locationManager.rx
            .authStatus
            .share(replay: 1)

        authStatus
            .map { $0.isAuthorized() }
            .distinctUntilChanged()
            .bind(to: isAuthorized)
            .disposed(by: bag)

        authStatus
            .map { $0.isDenied() }
            .distinctUntilChanged()
            .bind(to: isDenied)
            .disposed(by: bag)
    }
}

extension LocationInteractor: LocationInteractorInterface {
    func requestLocation() -> Single<CLLocationCoordinate2D> {
        locationManager.requestLocation()
    }
}
