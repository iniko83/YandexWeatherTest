//
//  UIViewController+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import UIKit

extension UIViewController {
    class func instantiateFromNib() -> Self {
        .init(
            nibName: String(describing: Self.self),
            bundle: nil
        )
    }
}
