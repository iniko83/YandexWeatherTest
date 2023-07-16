//
//  WeatherViewController.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import RxSwift

@IBDesignable
final class WeatherViewController: MvpViewController<WeatherPresenter>, MvpView {
    private var bag = DisposeBag()

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var indicationContainerView: UIView!

    @IBOutlet weak var factView: WeatherFactView!
    @IBOutlet weak var forecastView: WeatherForecastView!

    @IBOutlet private weak var connectionStatusView: ConnectionStatusView!
    @IBOutlet private weak var locationAuthStatusButton: WarningTextButton!

    @IBOutlet private var connectionStatusHideConstraint: NSLayoutConstraint!
    @IBOutlet private var locationAuthStatusHideConstraint: NSLayoutConstraint!

    private var animated = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        bindViews()

        self.animated = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.animated = false
    }

    // MARK: -
    private func bindViews() {
        bag = .init()

        guard
            let model: WeatherPresenterViewDataSource = presenter,
            let actions: WeatherPresenterViewActions = presenter
        else { return }

        connectionStatusView.bind(model.connectionStatusViewModel())
        locationAuthStatusButton.bind(model.locationAuthStatusButtonModel(actions))
    }
}

extension WeatherViewController: WeatherView {
    func updateLocationAvailabilityStatus(isShowing: Bool) {
        updateConstraint(
            locationAuthStatusHideConstraint,
            isActive: !isShowing
        )
    }

    func updateNetworkAvailabilityStatus(isShowing: Bool) {
        updateConstraint(
            connectionStatusHideConstraint,
            isActive: !isShowing
        )
    }

    // MARK: -
    private func updateConstraint(
        _ constraint: NSLayoutConstraint,
        isActive: Bool
    ) {
        guard constraint.isActive != isActive else { return }

        constraint.isActive = isActive
        UIAnimator.animate(
            animated: animated,
            kind: .updateCollection,
            animations: { self.view.layoutIfNeeded() }
        )
    }
}

fileprivate extension WeatherPresenterViewDataSource {
    typealias Actions = WeatherPresenterViewActions

    func connectionStatusViewModel() -> ConnectionStatusView.Model {
        .init(isConnected: isNetworkAvailable)
    }

    func locationAuthStatusButtonModel(_ actions: Actions) -> WarningTextButton.Model {
        let result = WarningTextButton.Model(isEnabled: isLocationServicesDenied)
        let bag = result.bag

        isLocationServicesDenied
            .map { isDenied in
                isDenied
                    ? "Location services denied"
                    : "Location services available"
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
