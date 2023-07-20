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
    func selectForecastKind(_ kind: Weather.Forecast.Kind)
    func selectForecastIndex(_ index: Int)

    func tapOnCancelAtLocationDeniedAlert()
    func tapOnOpenSettingsAtLocationDeniedAlert()

    func tapOnDeniedLocationServices()
    func tapOnLocationButton()

    func viewDidAppear()
}

extension WeatherPresenter {
    typealias View = WeatherViewController
}

final class WeatherPresenter: MvpPresenter {
    private var bag = DisposeBag()
    private var requestForecastBag = DisposeBag()
    private var requestLocationBag = DisposeBag()
    private let model: Model

    var view: WeatherViewController?

    private let locationInteractor: LocationInteractor = Resolver.resolve()
    private let networkAvailabilityInteractor: NetworkAvailabilityInteractor = Resolver.resolve()
    private let weatherNetworkInteractor: WeatherNetworkInteractor = Resolver.resolve()

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

    // MARK: - Request Forecast
    private func onRequestForecastSuccess(_ value: Weather.Response) {
        let localityName = value.locality.name

        model.weatherResponse.accept(value)
        model.localityName.accept(localityName)
    }

    private func requestForecast(_ coordinate: Coordinate) {
        requestForecastBag = .init()

        let response = weatherNetworkInteractor
            .fetchRequest(.forecast(coordinate))
            .asObservable()
            .share(replay: 1)

        response
            .subscribe(onNext: { [unowned self] value in
                self.onRequestForecastSuccess(value)
            })
            .disposed(by: requestForecastBag)

        response
            .loadingState()
            .bind(to: model.weatherLoadingState)
            .disposed(by: requestForecastBag)
    }

    // MARK: - Request location
    private func isNeedRequestLocation() -> Bool {
        model.weatherCoordinate.value?.isDefault ?? true
    }

    private func onRequestLocationSuccess(_ value: CLLocationCoordinate2D) {
        let coordinate = WeatherCoordinate(locationCoordinate: value)
        model.weatherCoordinate.acceptDifferent(coordinate)
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

        locationInteractor
            .requestLocation()
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
        model.weatherCoordinate.acceptDifferent(.default)
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
    func selectForecastIndex(_ index: Int) {
        model.weatherForecastIndex.acceptDifferent(index)
    }

    func selectForecastKind(_ kind: Weather.Forecast.Kind) {
        model.weatherForecastKind.acceptDifferent(kind)
    }

    func tapOnCancelAtLocationDeniedAlert() {
        setDefaultWeatherLocationIfNil()
    }

    func tapOnOpenSettingsAtLocationDeniedAlert() {
        UIApplication.openSettings()
        setDefaultWeatherLocationIfNil()
    }

    func tapOnDeniedLocationServices() {
        UIApplication.openSettings()
    }

    func tapOnLocationButton() {
        requestLocation()
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

    var localityName: BehaviorRelay<String?> {
        get { model.localityName }
    }

    var weatherCoordinate: BehaviorRelay<WeatherCoordinate?> {
        get { model.weatherCoordinate }
    }

    var weatherForecastKind: BehaviorRelay<Weather.Forecast.Kind> {
        get { model.weatherForecastKind }
    }

    var weatherForecastIndex: BehaviorRelay<Int> {
        get { model.weatherForecastIndex }
    }

    var weatherLoadingState: BehaviorRelay<LoadingState?> {
        get { model.weatherLoadingState }
    }

    var weatherResponse: BehaviorRelay<Weather.Response?> {
        get { model.weatherResponse }
    }
}

extension WeatherPresenter: Connectable {
    struct Model {
        // inputs
        let requestLocation: PublishRelay<Void>

        // outputs
        let isLocationServicesDenied: BehaviorRelay<Bool>
        let isNetworkAvailable: BehaviorRelay<Bool>

        let localityName: BehaviorRelay<String?>

        let weatherCoordinate: BehaviorRelay<WeatherCoordinate?>
        let weatherForecastKind: BehaviorRelay<Weather.Forecast.Kind>
        let weatherForecastIndex: BehaviorRelay<Int>
        let weatherLoadingState: BehaviorRelay<LoadingState?>
        let weatherResponse: BehaviorRelay<Weather.Response?>
    }

    func connect(_ model: Model) {
        bindViewUpdates(model)
        bindForecastRequests(model)
        bindLocationRequests(model)

        requestLocationIfRequired()
    }

    func disconnect() {
        bag = .init()
        requestForecastBag = .init()
        requestLocationBag = .init()
    }

    private func bindForecastRequests(_ model: Model) {
        let coordinate = model.weatherCoordinate
            .compactMap { $0?.coordinate }
            .distinctUntilChanged()
            .share(replay: 1)

        let coordinateViaReconnection = model.isNetworkAvailable
            .filter { $0 }
            .withLatestFrom(model.weatherLoadingState)
            .filter { loadingState in
                loadingState?.isRetryableError() ?? false
            }
            .withLatestFrom(coordinate)

        Observable
            .merge(
                coordinate,
                coordinateViaReconnection
            )
            .subscribe(onNext: { [unowned self] coordinate in
                self.requestForecast(coordinate)
            })
            .disposed(by: bag)
    }

    private func bindLocationRequests(_ model: Model) {
        model.requestLocation
            .subscribe(onNext: { [unowned self] in self.requestLocation() })
            .disposed(by: bag)
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
}

extension WeatherPresenter.Model {
    init(
        isLocationServicesDenied: BehaviorRelay<Bool>,
        isNetworkAvailable: BehaviorRelay<Bool>
    ) {
        requestLocation = .init()

        self.isLocationServicesDenied = isLocationServicesDenied
        self.isNetworkAvailable = isNetworkAvailable

        localityName = .init()

        weatherCoordinate = .init()
        weatherForecastKind = .init()
        weatherForecastIndex = .init()
        weatherLoadingState = .init()
        weatherResponse = .init()
    }
}
