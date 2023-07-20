//
//  WeatherForecastTableContainerView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 20.07.2023.
//

import RxRelay
import RxSwift

extension WeatherForecastTableContainerView {
    typealias IndicationDataSource = WeatherForecastTableIndicationViewDataSource
    typealias IndicationManager = IndicationViewManager<IndicationViewProvider>
    typealias IndicationViewProvider = WeatherForecastTableIndicationViewProvider
}

@IBDesignable
final class WeatherForecastTableContainerView: UIView, NibOwnerLoadable {
    private let indicationManager = IndicationManager()

    @IBOutlet private weak var headerView: WeatherBaseInfoHeaderView!
    @IBOutlet private weak var tableManagerView: WeatherForecastTableManagerView!

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var indicationView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
}

extension WeatherForecastTableContainerView: Connectable {
    func connect(_ model: Model) {
        headerView.connect(model.headerViewModel())
        tableManagerView.connect(model.tableManagerViewModel())

        indicationManager.connect(indicationManagerModel(model))
    }

    func disconnect() {
        headerView.disconnect()
        tableManagerView.disconnect()
        
        indicationManager.disconnect()
    }

    private func indicationManagerModel(
        _ indicationDataSource: IndicationDataSource
    ) -> IndicationManager.Model {
        .init(
            tag: indicationDataSource.indicationState,
            provider: .init(indicationDataSource: indicationDataSource),
            containerView: indicationView,
            hideableContentView: contentView
        )
    }
}

extension WeatherForecastTableContainerView {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let forecast: BehaviorRelay<Weather.Forecast>
        let selectedKind: BehaviorRelay<Weather.Forecast.Kind>

        // outputs
        let indicationState: BehaviorRelay<EmptyState?>
        let tableItems: BehaviorRelay<[Weather.Forecast.Identificator]>

        // data
        let color: UIColor

        // MARK: - Init
        init(
            forecast: BehaviorRelay<Weather.Forecast>,
            selectedKind: BehaviorRelay<Weather.Forecast.Kind>,
            color: UIColor
        ) {
            self.forecast = forecast
            self.selectedKind = selectedKind
            indicationState = .init()
            tableItems = .init()
            self.color = color

            bindOutputs()
        }

        private func bindOutputs() {
            Observable
                .combineLatest(
                    forecast,
                    selectedKind
                )
                .map { (forecast, kind) in forecast.identificators(kind: kind) }
                .distinctUntilChanged()
                .bind(to: tableItems)
                .disposed(by: bag)

            tableItems
                .map { value -> EmptyState? in
                    value.isEmpty
                        ? .init()
                        : nil
                }
                .distinctUntilChanged()
                .bind(to: indicationState)
                .disposed(by: bag)
        }

        // MARK: - Models
        fileprivate func headerViewModel() -> WeatherBaseInfoHeaderView.Model {
            .init(color: color)
        }

        fileprivate func tableManagerViewModel() -> WeatherForecastTableManagerView.Model {
            .init(
                forecast: forecast,
                items: tableItems,
                color: color
            )
        }
    }
}

extension WeatherForecastTableContainerView.Model: WeatherForecastTableIndicationViewDataSource {
    func indicationEmptyViewModel() -> IndicationInfoView.Model {
        .init(
            icon: .unknownError,
            text: L10n.Text.noForecast
        )
    }
}
