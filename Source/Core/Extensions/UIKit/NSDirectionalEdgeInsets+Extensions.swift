//
//  NSDirectionalEdgeInsets+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import UIKit.UIGeometry

extension NSDirectionalEdgeInsets {
    init(value: CGFloat) {
        self.init(
            top: value,
            leading: value,
            bottom: value,
            trailing: value
        )
    }
}
