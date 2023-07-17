//
//  WeatherPresenter.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import CoreLocation
import Resolver
import RxRelay
import RxSwift

protocol WeatherPresenterViewActions: AnyObject {
    func tapOnCancelAtLocationDeniedAlert()
    func tapOnDeniedLocationServices()

    func viewDidAppear()
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
    private var requestLocationBag = DisposeBag()

    var view: WeatherViewController?

    private let locationInteractor: LocationInteractor = Resolver.resolve()
    private let networkAvailabilityInteractor: NetworkAvailabilityInteractor = Resolver.resolve()

    private var isViewDidAppear = false

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

        isViewDidAppear = false
    }

    // MARK: - Request location
    private func isNeedRequestLocation() -> Bool {
        model.weatherCoordinate.value?.isDefault ?? true
    }

    private func onRequestLocationSuccess(_ value: CLLocationCoordinate2D) {
        let coordinate = WeatherCoordinate(locationCoordinate: value)
        model.weatherCoordinate.accept(coordinate)
    }

    private func onRequestLocationFailure(_ error: Error) {
        guard
            let error = error as? CLError,
            error.code == .denied,
            isViewDidAppear
        else { return }

        view?.showLocationDeniedAlert()
    }

    private func requestLocation() {
        requestLocationBag = .init()

        locationInteractor.requestLocation()
            .subscribe(
                onSuccess: { [unowned self] value in self.onRequestLocationSuccess(value) },
                onFailure: { [unowned self] error in self.onRequestLocationFailure(error) }
            )
            .disposed(by: requestLocationBag)
    }

    private func requestLocationIfRequired() {
        guard isNeedRequestLocation() else { return }
        model.requestLocation.accept(Void())
    }

    private func setDefaultWeatherLocationIfNil() {
        guard model.weatherCoordinate.value == nil else { return }
        model.weatherCoordinate.accept(.default)
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
    func tapOnCancelAtLocationDeniedAlert() {
        setDefaultWeatherLocationIfNil()
    }

    func tapOnDeniedLocationServices() {
        UIApplication.openSettings()
    }

    func viewDidAppear() {
        isViewDidAppear = true

        if isNeedRequestLocation() {
            requestLocation()
        }
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
        // inputs
        let requestLocation: PublishRelay<Void>

        // outputs
        let isLocationServicesDenied: BehaviorRelay<Bool>
        let isNetworkAvailable: BehaviorRelay<Bool>

        let weatherCoordinate: BehaviorRelay<WeatherCoordinate?>
    }

    func connect(_ model: Model) {
        bindViewUpdates(model)
        bindLocationRequests(model)

        requestLocationIfRequired()
    }

    func disconnect() {
        bag = .init()
        requestLocationBag = .init()
    }

    private func bindViewUpdates(_ model: Model) {
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

    private func bindLocationRequests(_ model: Model) {
        model.requestLocation
            .subscribe(onNext: { [unowned self] in self.requestLocation() })
            .disposed(by: bag)
    }
}

extension WeatherPresenter.Model {
    init(
        isLocationServicesDenied: BehaviorRelay<Bool>,
        isNetworkAvailable: BehaviorRelay<Bool>
    ) {
        requestLocation = .init()

        self.isLocationServicesDenied = isLocationServicesDenied
        self.isNetworkAvailable = isNetworkAvailable

        weatherCoordinate = .init()
    }
}
