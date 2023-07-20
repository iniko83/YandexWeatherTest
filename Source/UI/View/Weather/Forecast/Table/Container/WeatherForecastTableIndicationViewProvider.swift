//
//  WeatherForecastTableIndicationViewProvider.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import RxRelay

protocol WeatherForecastTableIndicationViewDataSource {
    var indicationState: BehaviorRelay<EmptyState?> { get }

    func indicationEmptyViewModel() -> IndicationInfoView.Model
}

extension WeatherForecastTableIndicationViewProvider {
    typealias IndicationDataSource = WeatherForecastTableIndicationViewDataSource
}

final class WeatherForecastTableIndicationViewProvider: EmptyIndicationViewProviderProtocol {
    private var indicationDataSource: IndicationDataSource?

    init(indicationDataSource: IndicationDataSource) {
        self.indicationDataSource = indicationDataSource
    }

    func indicationView(_ tag: EmptyState) -> UIView {
        guard let indicationDataSource else { return .init() }

        let result = IndicationInfoView()
        let model = indicationDataSource.indicationEmptyViewModel()
        result.bind(model)
        return result
    }
}
