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

extension CGSize {
    init(side: CGFloat) {
        self.init(
            width: side,
            height: side
        )
    }
}

extension CGSize {
    func minimumSide() -> CGFloat {
        min(width, height)
    }
}
