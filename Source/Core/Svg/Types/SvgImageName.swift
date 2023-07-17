//
//  SvgImageName.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 12.07.2023.
//

import Foundation

extension SvgImageName {
    static let noImage = Self.local(.noImage)
}

enum SvgImageName: Hashable {
    case local(Local)
    case network(icon: String)

    func isLocal() -> Bool {
        guard case .local = self else { return false }
        return true
    }
}

extension SvgImageName {
    enum Local: String {
        case noImage

        case humidity
        case location
        case wind
        case windDirection

        case connectionLost
        case serverOffline
        case unknownError
    }
}
