//
//  WeatherViewController.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import RxSwift

extension WeatherViewController {
    typealias IndicationDataSource = WeatherPresenterViewDataSource
    typealias IndicationManager = IndicationViewManager<IndicationViewProvider>
    typealias IndicationViewProvider = WeatherIndicationViewProvider
    typealias Model = Presenter
}

@IBDesignable
final class WeatherViewController: MvpViewController<WeatherPresenter>, MvpView {
    private let indicationManager = IndicationManager()

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var indicationView: UIView!

    @IBOutlet private weak var factMainView: WeatherFactMainView!
    @IBOutlet private weak var forecastMainView: WeatherForecastMainView!

    @IBOutlet private weak var connectionStatusView: ConnectionStatusView!
    @IBOutlet private weak var locationAuthStatusButton: WarningTextButton!

    @IBOutlet private var connectionStatusHideConstraint: NSLayoutConstraint!
    @IBOutlet private var locationAuthStatusHideConstraint: NSLayoutConstraint!

    private var animated = false

    private var isConnected = false

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        let isControllerDisplaying = animated
        if !isControllerDisplaying {
            disconnect()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !isConnected, let model = presenter {
            bind(model)
        }

        self.animated = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter?.viewDidAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.animated = false
    }
}

extension WeatherViewController: Connectable {
    func connect(_ model: WeatherPresenter) {
        let actions = model as WeatherPresenterViewActions

        factMainView.connect(model.factMainViewModel(actions))
        forecastMainView.connect(model.forecastMainViewModel(actions))
        connectionStatusView.connect(model.connectionStatusViewModel())
        locationAuthStatusButton.connect(model.locationAuthStatusButtonModel(actions))

        indicationManager.connect(indicationManagerModel(model))

        isConnected = true
    }

    func disconnect() {
        factMainView.disconnect()
        forecastMainView.disconnect()
        connectionStatusView.disconnect()
        locationAuthStatusButton.disconnect()

        indicationManager.disconnect()

        isConnected = false
    }

    // MARK: - Models
    private func indicationManagerModel(
        _ indicationDataSource: IndicationDataSource
    ) -> IndicationManager.Model {
        .init(
            tag: indicationDataSource.weatherLoadingState,
            provider: .init(indicationDataSource: indicationDataSource),
            containerView: indicationView,
            hideableContentView: contentView
        )
    }
}

extension WeatherViewController: WeatherView {
    func showLocationDeniedAlert() {
        let alertController = UIAlertController.make(
            message: L10n.WeatherController.Alert.LocationServicesDenied.message,
            actions: [
                .default(
                    L10n.Action.openSettings,
                    handler: { self.presenter?.tapOnOpenSettingsAtLocationDeniedAlert() }
                ),
                .cancel(handler: { self.presenter?.tapOnCancelAtLocationDeniedAlert() })
            ]
        )
        present(alertController, animated: animated)
    }

    func updateLocationAvailabilityStatus(isShowing: Bool) {
        updateWarningView(
            locationAuthStatusButton,
            hideConstraint: locationAuthStatusHideConstraint,
            isShowing: isShowing
        )
    }

    func updateNetworkAvailabilityStatus(isShowing: Bool) {
        updateWarningView(
            connectionStatusView,
            hideConstraint: connectionStatusHideConstraint,
            isShowing: isShowing
        )
    }

    // MARK: -
    private func updateWarningView(
        _ view: UIView,
        hideConstraint: NSLayoutConstraint,
        isShowing: Bool
    ) {
        hideConstraint.isActive = !isShowing
        view.isHidden = false

        UIAnimator.animate(
            animated: animated,
            kind: .updateCollection,
            animations: {
                view.alpha = isShowing ? 1 : 0
                self.view.layoutIfNeeded()
            },
            completion: {
                view.isHidden = !isShowing
            }
        )
    }
}
