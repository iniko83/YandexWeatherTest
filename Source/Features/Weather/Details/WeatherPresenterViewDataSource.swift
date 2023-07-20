//
//  WeatherPresenterViewDataSource.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import RxCocoa
import RxSwift

protocol WeatherPresenterViewDataSource: AnyObject {
    var isLocationServicesDenied: BehaviorRelay<Bool> { get }
    var isNetworkAvailable: BehaviorRelay<Bool> { get }

    var localityName: BehaviorRelay<String?> { get }

    var weatherCoordinate: BehaviorRelay<WeatherCoordinate?> { get }
    var weatherForecastKind: BehaviorRelay<Weather.Forecast.Kind> { get }
    var weatherForecastIndex: BehaviorRelay<Int> { get }
    var weatherLoadingState: BehaviorRelay<LoadingState?> { get }
    var weatherResponse: BehaviorRelay<Weather.Response?> { get }
}

extension WeatherPresenterViewDataSource {
    typealias Actions = WeatherPresenterViewActions
}

extension WeatherPresenterViewDataSource {
    func connectionStatusViewModel() -> ConnectionStatusView.Model {
        .init(isConnected: isNetworkAvailable)
    }

    func factMainViewModel(_ actions: Actions) -> WeatherFactMainView.Model {
        let result = WeatherFactMainView.Model(
            forecastSelectedIndex: weatherForecastIndex,
            localityName: localityName,
            color: mainContentColor(),
            attentionColor: attentionColor()
        )
        let bag = result.bag

        let response = weatherResponse
            .compactMap { $0 }
            .share(replay: 1)

        response
            .map { $0.fact }
            .distinctUntilChanged()
            .bind(to: result.fact)
            .disposed(by: bag)

        response
            .map { response in
                response.forecasts.map { $0.date }
            }
            .distinctUntilChanged()
            .bind(to: result.forecastDates)
            .disposed(by: bag)

        weatherCoordinate
            .map { $0?.isDefault ?? true }
            .distinctUntilChanged()
            .bind(to: result.isDefaultCoordinate)
            .disposed(by: bag)

        result.selectForecastIndex
            .subscribe(onNext: { value in actions.selectForecastIndex(value) })
            .disposed(by: bag)

        result.tapLocation
            .subscribe(onNext: { actions.tapOnLocationButton() })
            .disposed(by: bag)

        return result
    }

    func forecastMainViewModel(_ actions: Actions) -> WeatherForecastMainView.Model {
        let result = WeatherForecastMainView.Model(
            selectedKind: weatherForecastKind,
            color: mainContentColor()
        )
        let bag = result.bag

        Observable
            .combineLatest(
                weatherResponse,
                weatherForecastIndex
            )
            .compactMap { (response, index) in response?.forecasts[safe: index] }
            .distinctUntilChanged()
            .bind(to: result.forecast)
            .disposed(by: bag)

        result.selectKind
            .subscribe(onNext: { value in actions.selectForecastKind(value) })
            .disposed(by: bag)

        return result
    }

    func indicationLoadingViewModel() -> IndicationLoadingView.Model {
        .init(
            activityColor: Asset.Assets.activity.color,
            shimmerColor: Asset.Assets.background.color
        )
    }

    func indicationErrorViewModel(error: PresentableError) -> IndicationInfoView.Model {
        .init(
            icon: error.kind.icon(),
            text: error.message()
        )
    }

    func locationAuthStatusButtonModel(_ actions: Actions) -> WarningTextButton.Model {
        let result = WarningTextButton.Model(isEnabled: isLocationServicesDenied)
        let bag = result.bag

        isLocationServicesDenied
            .map { isDenied in
                isDenied
                    ? L10n.LocationServices.Warning.denied
                    : L10n.LocationServices.Warning.available
            }
            .bind(to: result.text)
            .disposed(by: bag)

        result.tap
            .subscribe(onNext: { [weak actions] in
                actions?.tapOnDeniedLocationServices()
            })
            .disposed(by: bag)

        return result
    }

    // MARK: -
    private func attentionColor() -> UIColor {
        Asset.Assets.warningOrange.color
    }

    private func mainContentColor() -> UIColor {
        Asset.Assets.text.color
    }
}
