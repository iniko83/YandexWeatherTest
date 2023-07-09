//
//  ApiRequest.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

final class ApiRequest {
    let path: String
    let method: HttpMethod

    let headers: [String: String]?
    let parameters: [String: Any]?
    let urlQuery: [String: CustomStringConvertible]?

    init(
        path: String,
        method: HttpMethod = .get,
        headers: [String: String]? = nil,
        parameters: [String: Any]? = nil,
        urlQuery: [String: CustomStringConvertible]? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.urlQuery = urlQuery
    }

    func urlRequest(_ baseUrl: URL) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = baseUrl.scheme
        components.host = baseUrl.host
        components.path = baseUrl.path
        components.queryItems = urlQuery?.map { (name, value) in
            .init(
                name: name,
                value: value.description
            )
        }

        guard let url = components.url?.appendingPathComponent(path) else {
            let error = WrongUrlError(
                baseUrl: baseUrl,
                path: path
            )
            throw PresentableError(error: error)
        }

        var result = URLRequest(url: url)
        result.httpMethod = method.string()

        if let parameters {
            do {
                result.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                throw PresentableError(error: error)
            }
            result.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        headers?.forEach { (field, value) in
            result.addValue(value, forHTTPHeaderField: field)
        }

        return result
    }
}
