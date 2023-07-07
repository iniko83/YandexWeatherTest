//
//  CLLocationManager+Rx.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 07.07.2023.
//

import CoreLocation
import RxCocoa
import RxSwift

extension CLLocationManager: HasDelegate {
    public typealias Delegate = CLLocationManagerDelegate
}

final class RxCLLocationManagerDelegateProxy:
    DelegateProxy<CLLocationManager, CLLocationManagerDelegate>,
    DelegateProxyType, CLLocationManagerDelegate
{
    private(set) weak var locationManager: CLLocationManager?

    init(locationManager: ParentObject) {
        self.locationManager = locationManager
        super.init(
            parentObject: locationManager,
            delegateProxy: RxCLLocationManagerDelegateProxy.self
        )
    }

    static func registerKnownImplementations() {
        register { locationManager in
            RxCLLocationManagerDelegateProxy(locationManager: locationManager)
        }
    }
}

extension Reactive where Base: CLLocationManager {
    var delegate : DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        RxCLLocationManagerDelegateProxy.proxy(for: base)
    }

    var authStatus: Observable<CLAuthorizationStatus> {
        didChangeAuthorizationStatus
            .startWith(base.getAuthorizationStatus())
            .asObservable()
    }

    var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
        let result: Observable<CLAuthorizationStatus>
        if #available(iOS 14, *) {
            result = delegate
                .methodInvoked(#selector(CLLocationManagerDelegate.locationManagerDidChangeAuthorization(_:)))
                .map { parameters in
                    let locationManager = parameters[0] as! CLLocationManager
                    return locationManager.authorizationStatus
                }
        } else {
            result = delegate
                .methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorization:)))
                .map { parameters in parameters[1] as! CLAuthorizationStatus }
        }
        return result
    }

    var didFailWithError: Observable<Error> {
        delegate
            .methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didFailWithError:)))
            .map { parameters in parameters[1] as! Error }
    }

    var didUpdateLocation: Observable<[CLLocation]> {
        delegate
            .methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { parameters in parameters[1] as! [CLLocation] }
    }
}
