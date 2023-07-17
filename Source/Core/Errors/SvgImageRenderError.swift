//
//  SvgImageRenderError.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 16.07.2023.
//

import Foundation

enum SvgImageRenderError: Error {
    case failedRenderLocalSvg(name: SvgImageName.Local)
    case notFoundRenderContainerView
}

extension SvgImageRenderError: LocalizedError {
    public var errorDescription: String? {
        let result: String
        switch self {
        case let .failedRenderLocalSvg(name):
            result = L10n.SvgRenderError.failedRenderLocalSvg(name.rawValue)
        case .notFoundRenderContainerView:
            result = L10n.SvgRenderError.notFoundRenderContainerView
        }
        return result
    }
}
