//
//  WeatherPresenter.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import Resolver
import RxRelay
import RxSwift

protocol WeatherPresenterViewActions: AnyObject {
    func tapOnDeniedLocationServices()
}

protocol WeatherPresenterViewDataSource {
    var isLocationServicesDenied: BehaviorRelay<Bool> { get }
    var isNetworkAvailable: BehaviorRelay<Bool> { get }
}

extension WeatherPresenter {
    typealias View = WeatherViewController
}

final class WeatherPresenter: MvpPresenter {
    private var bag = DisposeBag()
    private let model: Model

    var view: WeatherViewController?

    private let locationInteractor: LocationInteractor = Resolver.resolve()
    private let networkAvailabilityInteractor: NetworkAvailabilityInteractor = Resolver.resolve()

    init() {
        model = .init(
            isLocationServicesDenied: locationInteractor.isDenied,
            isNetworkAvailable: .init(value: networkAvailabilityInteractor.isNetworkAvailable)
        )

        observeNetworkAvailability(true)
    }

    deinit {
        observeNetworkAvailability(false)
    }

    func attachView(_ view: WeatherViewController) {
        self.view = view
        view.presenter = self

        bind(model)
    }

    func detachView() {
        disconnect()

        view?.presenter = nil
        view = nil
    }

    // MARK: - Subscription support
    private func observeNetworkAvailability(_ isObserve: Bool) {
        let notificationCenter = NotificationCenter.default
        if isObserve {
            notificationCenter.addObserver(
                self,
                selector: #selector(onChangeNetworkAvailabilityStatus),
                name: .didChangeNetworkAvailabilityStatus,
                object: nil
            )
        } else {
            notificationCenter.removeObserver(
                self,
                name: .didChangeNetworkAvailabilityStatus,
                object: nil
            )
        }
    }

    @objc
    private func onChangeNetworkAvailabilityStatus() {
        let isNetworkAvailable = networkAvailabilityInteractor.isNetworkAvailable
        model.isNetworkAvailable.acceptDifferent(isNetworkAvailable)
    }
}

extension WeatherPresenter: WeatherPresenterViewActions {
    func tapOnDeniedLocationServices() {
        UIApplication.openSettings()
    }
}

extension WeatherPresenter: WeatherPresenterViewDataSource {
    var isLocationServicesDenied: BehaviorRelay<Bool> {
        get { model.isLocationServicesDenied }
    }

    var isNetworkAvailable: BehaviorRelay<Bool> {
        get { model.isNetworkAvailable }
    }
}

extension WeatherPresenter: Connectable {
    struct Model {
        // outputs
        let isLocationServicesDenied: BehaviorRelay<Bool>
        let isNetworkAvailable: BehaviorRelay<Bool>
    }

    func connect(_ model: Model) {
        model.isLocationServicesDenied
            .subscribe(onNext: { [unowned self] value in
                self.view?.updateLocationAvailabilityStatus(isShowing: value)
            })
            .disposed(by: bag)

        model.isNetworkAvailable
            .subscribe(onNext: { [unowned self] value in
                self.view?.updateNetworkAvailabilityStatus(isShowing: !value)
            })
            .disposed(by: bag)
    }

    func disconnect() {
        bag = .init()
    }
}
