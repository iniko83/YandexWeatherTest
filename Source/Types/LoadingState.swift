//
//  LoadingState.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 18.07.2023.
//

import Foundation

protocol LoadingIndicationViewProviderProtocol: IndicationViewProviderProtocol where
    Tag == LoadingState {}

enum LoadingState: Equatable {
    case loading
    case error(PresentableError)

    func isLoading() -> Bool {
        self == .loading
    }

    func isRetryableError() -> Bool {
        guard case let .error(error) = self else { return false }
        return error.isRetryable()
    }
}
