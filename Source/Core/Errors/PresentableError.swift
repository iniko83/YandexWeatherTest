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
    func icon() -> SvgImageName.Local {
        let result: SvgImageName.Local
        switch self {
        case .connectionLost:
            result = .connectionLost
        case .serverOffline:
            result = .serverOffline
        default:
            result = .unknownError
        }
        return result
    }

    func message() -> String {
        let result: String
        switch self {
        case .unknown:
            result = L10n.PresentableError.unknown
        case .decoding:
            result = L10n.PresentableError.decoding
        case .encoding:
            result = L10n.PresentableError.encoding
        case .wrongUrl:
            result = L10n.PresentableError.wrongUrl
        case .forbiddenRequest:
            result = L10n.PresentableError.forbiddenRequest
        case .connectionLost:
            result = L10n.PresentableError.connectionLost
        case .serverOffline:
            result = L10n.PresentableError.serverOffline
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
