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

// FIXME: add localization
/*
extension SvgImageRenderError: LocalizedError {
    public var errorDescription: String? {
        let result: String?
        switch self {
        case let .failedRenderLocalSvg(name):
            result = "Failed generate image for local svg with name \"\(name.rawValue)\".")
        case .notFoundRenderContainerView:
            result = "Failed find containerView for render svg images."
        }
        return result
    }
}
*/
