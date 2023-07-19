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

    func indicationLoadingViewModel() -> IndicationLoadingView.Model {
        .init(
            activityColor: .activity,
            shimmerColor: .shimmer
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
}

// MARK: - Constants
private extension UIColor {
    // FIXME: - colors
    static let activity = UIColor.orange.withAlphaComponent(0.2)
    static let shimmer = UIColor.lightGray.withAlphaComponent(0.3)
}
