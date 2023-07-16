//
//  URLSession+RxExtensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import RxSwift

extension URLSession {
    func request(_ apiRequest: ApiRequest, baseUrl: URL) -> Single<ApiResponse> {
        let result: Single<ApiResponse>
        do {
            let request = try apiRequest.urlRequest(baseUrl)
            result = self.request(request)
        }
        catch {
            result = .error(error)
        }
        return result
    }

    func request(_ urlRequest: URLRequest) -> Single<ApiResponse> {
        .create { [unowned self] observer in
            let task = self.dataTask(with: urlRequest) { (data, response, error) in
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
