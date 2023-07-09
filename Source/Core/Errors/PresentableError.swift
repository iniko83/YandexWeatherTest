//
//  PresentableError.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

struct PresentableError: Error, Equatable {
    let kind: PresentableErrorKind
    let underlying: Error?

    func isRetryable() -> Bool {
        kind.isRetryable()
    }

    func message() -> String {
        kind.message()
    }

    func title() -> String? {
        kind.title()
    }

    // MARK: - Equatable
    static func == (lhs: PresentableError, rhs: PresentableError) -> Bool {
        lhs.kind == rhs.kind
    }
}

extension PresentableError {

    init(error: Error) {
        switch error {
        case let error as PresentableError:
            self = error

        case let error as DecodingError:
            self.init(
                kind: .decoding,
                underlying: error
            )

        case let error as EncodingError:
            self.init(
                kind: .encoding,
                underlying: error
            )

        case let error as URLError:
            self.init(error: error)

        case let error as WrongUrlError:
            self.init(
                kind: .wrongUrl,
                underlying: error
            )

        default:
            self.init(
                kind: .unknown,
                underlying: error
            )
        }
    }

    init(error: URLError) {
        self.init(
            kind: .init(error: error),
            underlying: error
        )
    }

    init(kind: PresentableErrorKind) {
        self.init(
            kind: kind,
            underlying: nil
        )
    }
}

enum PresentableErrorKind: Int {
    case unknown = 0

    case decoding
    case encoding

    case wrongUrl

    case forbiddenRequest

    case connectionLost
    case serverOffline

    func isRetryable() -> Bool {
        self > .forbiddenRequest
    }

    // MARK: -
    func message() -> String {
        // FIXME: add localization support
        let result: String
        switch self {
        case .unknown:
            result = "unknown"
        case .decoding:
            result = "decoding"
        case .encoding:
            result = "encoding"
        case .wrongUrl:
            result = "wrongUrl"
        case .forbiddenRequest:
            result = "forbiddenRequest"
        case .connectionLost:
            result = "connectionLost"
        case .serverOffline:
            result = "serverOffline"
        }
        return result
    }

    func title() -> String {
        // FIXME: add localization support
        let result: String
        switch self {
        case .unknown:
            result = "title.unknown"
        case .decoding:
            result = "title.decoding"
        case .encoding:
            result = "title.encoding"
        case .wrongUrl, .forbiddenRequest, .connectionLost, .serverOffline:
            result = "Network error"
        }
        return result
    }
}

extension PresentableErrorKind {

    init(error: URLError) {
        switch error.code {
        case .cannotFindHost, .cannotConnectToHost:
            self = .serverOffline
        case .notConnectedToInternet:
            self = .connectionLost
        default:
            self = .forbiddenRequest
        }
    }
}
