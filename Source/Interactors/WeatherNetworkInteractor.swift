//
//  WeatherNetworkInteractor.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import RxSwift

protocol WeatherNetworkInteractorProtocol {
    func fetchRequest(_ request: Weather.Request) -> Single<Weather.Response>
}

final class WeatherNetworkInteractor {
    private let session: URLSession

    init() {
        session = Self.makeSession()
    }
}

extension WeatherNetworkInteractor: WeatherNetworkInteractorProtocol {
    func fetchRequest(_ request: Weather.Request) -> Single<Weather.Response> {
        session
            .request(
                request.apiRequest(),
                baseUrl: .baseUrl
            )
            .map(Weather.Response.self)
    }
}

// MARK: - Private
private extension WeatherNetworkInteractor {
    static func makeSession() -> URLSession {
        .init(
            configuration: makeSessionConfiguration(),
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
    }

    static func makeSessionConfiguration() -> URLSessionConfiguration {
        let result = URLSessionConfiguration.default
        result.httpAdditionalHeaders = [String.apiKeyHeader: String.apiKey]
        result.requestCachePolicy = .reloadRevalidatingCacheData
        result.timeoutIntervalForRequest = 15
        return result
    }
}

// MARK: - Constants
private extension String {
    static let apiKey = "a7fb43fa-4ce4-4779-81b5-b24041059338"
    static let apiKeyHeader = "X-Yandex-API-Key"
    static let baseUrl = "https://api.weather.yandex.ru/v2"
}

private extension URL {
    static let baseUrl = Self(string: .baseUrl)!
}
