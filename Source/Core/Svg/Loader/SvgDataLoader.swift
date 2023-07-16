//
//  SvgDataLoader.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 13.07.2023.
//

import RxSwift

protocol SvgDataLoaderProtocol {
    func loadSvgData(icon: String) -> Single<Data>
}

extension SvgDataLoader {
    typealias Callback = (Result) -> ()
    typealias Result = Swift.Result<Data, Error>
}

final class SvgDataLoader {
    private let bag = DisposeBag()

    private let session: URLSession

    private var callbacks = [String: [Callback]]()

    init() {
        session = Self.makeSession()
    }

    private func apiRequest(icon: String) -> ApiRequest {
        .init(path: "/\(icon).svg")
    }

    private func didLoadData(icon: String, result: Result) {
        guard let items = callbacks.removeValue(forKey: icon) else { return }

        for item in items {
            item(result)
        }
    }

    private func loadSvgData(icon: String, callback: @escaping Callback) {
        dispatchPrecondition(condition: .onQueue(DispatchQueue.main))

        var items = callbacks.removeValue(forKey: icon) ?? .init()
        let isProceed = items.isEmpty
        items.append(callback)
        callbacks[icon] = items

        guard isProceed else { return }

        session
            .request(
                apiRequest(icon: icon),
                baseUrl: .baseUrl
            )
            .map { apiResponse in apiResponse.data }
            .subscribe { [unowned self] event in
                self.didLoadData(icon: icon, result: event)
            }
            .disposed(by: bag)
    }
}

extension SvgDataLoader: SvgDataLoaderProtocol {
    func loadSvgData(icon: String) -> Single<Data> {
        .create { [unowned self] observer in
            self.loadSvgData(icon: icon) { result in
                switch result {
                case let .success(data):
                    observer(.success(data))
                case let .failure(error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}

// MARK: - Private
private extension SvgDataLoader {
    static func makeSession() -> URLSession {
        .init(
            configuration: makeSessionConfiguration(),
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
    }

    static func makeSessionConfiguration() -> URLSessionConfiguration {
        let result = URLSessionConfiguration.ephemeral
        result.timeoutIntervalForRequest = 10
        result.timeoutIntervalForResource = 10
        return result
    }
}

// MARK: - Constants
private extension String {
    static let baseUrl = "https://yastatic.net/weather/i/icons/funky/dark"
}

private extension URL {
    static let baseUrl = Self(string: .baseUrl)!
}
