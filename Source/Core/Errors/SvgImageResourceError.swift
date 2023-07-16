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

// FIXME: add localization
/*
extension SvgImageResourceError: LocalizedError {
    public var errorDescription: String? {
        "Please add \"\(name.rawValue).svg\" at \"Resources/Icons\" project folder."
    }
}
*/
