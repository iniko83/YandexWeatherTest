//
//  WeatherViewController.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import RxSwift

extension WeatherViewController {
    typealias DataSource = WeatherPresenterViewDataSource
    typealias IndicationManager = IndicationViewManager<WeatherIndicationViewProvider>
    typealias Model = Presenter
}

@IBDesignable
final class WeatherViewController: MvpViewController<WeatherPresenter>, MvpView {
    private var bag = DisposeBag()

    private let indicationManager = IndicationManager()

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var indicationContainerView: UIView!

    @IBOutlet weak var factView: WeatherFactView!
    @IBOutlet weak var forecastView: WeatherForecastView!

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
        let dataSource = model as DataSource

        indicationManager.bind(indicationManagerModel(dataSource))

        bindViews(model)

        isConnected = true
    }

    func disconnect() {
        bag = .init()

        isConnected = false
    }

    // MARK: - Models
    private func indicationManagerModel(_ dataSource: DataSource) -> IndicationManager.Model {
        .init(
            tag: dataSource.weatherLoadingState,
            provider: .init(dataSource: dataSource),
            containerView: indicationContainerView,
            hideableContentView: contentView
        )
    }

    // MARK: -
    private func bindViews(_ model: Model) {
        bag = .init()

        connectionStatusView.bind(model.connectionStatusViewModel())

        let actions = model as WeatherPresenterViewActions
        locationAuthStatusButton.bind(model.locationAuthStatusButtonModel(actions))
    }
}

extension WeatherViewController: WeatherView {
    func showLocationDeniedAlert() {
        let alertController = UIAlertController.make(
            message: L10n.WeatherController.Alert.LocationServicesDenied.message,
            actions: [
                .default(L10n.Action.openSettings, handler: { UIApplication.openSettings() }),
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
