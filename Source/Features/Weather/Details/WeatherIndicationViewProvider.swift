//
//  WeatherIndicationViewProvider.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import UIKit

extension WeatherIndicationViewProvider {
    typealias IndicationDataSource = WeatherPresenterViewDataSource
}

final class WeatherIndicationViewProvider: LoadingIndicationViewProviderProtocol {
    private weak var indicationDataSource: IndicationDataSource?

    init(indicationDataSource: IndicationDataSource) {
        self.indicationDataSource = indicationDataSource
    }

    func indicationView(_ tag: LoadingState) -> UIView {
        guard let indicationDataSource else { return .init() }

        let result: UIView
        switch tag {
        case .loading:
            let view = IndicationLoadingView()
            let model = indicationDataSource.indicationLoadingViewModel()
            view.bind(model)
            result = view

        case let .error(error):
            let view = IndicationInfoView()
            let model = indicationDataSource.indicationErrorViewModel(error: error)
            view.bind(model)
            result = view
        }
        return result
    }
}
