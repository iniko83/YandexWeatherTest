//
//  URLSession+RxExtensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import RxSwift

extension URLSession {
    func request(_ request: URLRequest) -> Single<ApiResponse> {
        return .create { [unowned self] observer in
            let task = self.dataTask(with: request) { (data, response, error) in
                if
                    let data,
                    let response,
                    let result = ApiResponse(response: response, data: data)
                {
                    observer(.success(result))
                } else {
                    let result: Error
                    if let error {
                        result = error
                    } else {
                        result = PresentableError(kind: .forbiddenRequest)
                    }
                    observer(.failure(result))
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
