//
//  WeatherIndicationDelegate.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import UIKit

protocol WeatherIndicationViewProviderProtocol: IndicationViewProviderProtocol where
    Tag == LoadingState {}

extension WeatherIndicationViewProvider {
    typealias DataSource = WeatherPresenterViewDataSource
}

final class WeatherIndicationViewProvider: WeatherIndicationViewProviderProtocol {
    private weak var dataSource: DataSource?

    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }

    func indicationView(_ tag: LoadingState) -> UIView {
        guard let dataSource else { return .init() }

        let result: UIView
        switch tag {
        case .loading:
            let view = IndicationLoadingView()
            let model = dataSource.indicationLoadingViewModel()
            view.bind(model)
            result = view

        case let .error(error):
            let view = IndicationInfoView()
            let model = dataSource.indicationErrorViewModel(error: error)
            view.bind(model)
            result = view
        }
        return result
    }
}
