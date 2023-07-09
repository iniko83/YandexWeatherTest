//
//  ApiResponse.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

final class ApiResponse {
    let statusCode: Int
    let data: Data

    init(
        statusCode: Int,
        data: Data
    ) {
        self.statusCode = statusCode
        self.data = data
    }

    convenience init?(
        response: URLResponse,
        data: Data
    ) {
        guard let response = response as? HTTPURLResponse else { return nil }

        self.init(
            statusCode: response.statusCode,
            data: data
        )
    }

    func filterSuccessfulStatusCodes() -> Bool {
        (200...299).contains(statusCode)
    }

    func map<Object: Decodable>(_ type: Object.Type) throws -> Object {
        let result: Object
        do {
            result = try JSONDecoder().decode(Object.self, from: data)
        } catch {
            throw PresentableError(error: error)
        }
        return result
    }

    func mapOptional<Object: Decodable>(_ type: Object.Type) -> Object? {
        try? JSONDecoder().decode(Object.self, from: data)
    }
}
