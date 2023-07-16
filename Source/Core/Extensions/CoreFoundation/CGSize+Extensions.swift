//
//  CGSize+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import UIKit

extension CGSize {
    static func noIntrinsic(height: CGFloat) -> Self {
        .init(
            width: UIView.noIntrinsicMetric,
            height: height
        )
    }
}
