//
//  SvgImageResourceError.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 16.07.2023.
//

import Foundation

struct SvgImageResourceError: Error {
    let name: SvgImageName.Local
}

extension SvgImageResourceError: LocalizedError {
    public var errorDescription: String? {
        L10n.SvgResourceError.notFoundIcon(name.rawValue)
    }
}
