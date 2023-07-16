//
//  UIApplication+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 11.07.2023.
//

import UIKit

extension UIApplication {
    @discardableResult
    static func openSettings() -> Bool {
        guard
            let url = URL(string: Self.openSettingsURLString),
            shared.canOpenURL(url)
        else { return false }

        shared.open(
            url,
            options: [:],
            completionHandler: nil
        )

        return true
    }
}
