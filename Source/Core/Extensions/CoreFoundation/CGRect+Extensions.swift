//
//  CGRect+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 18.07.2023.
//

import UIKit

extension CGRect {
    init(
        center: CGPoint,
        size: CGSize
    ) {
        self.init(
            origin: .init(
                x: center.x - 0.5 * size.width,
                y: center.y - 0.5 * size.height
            ),
            size: size
        )
    }

    init(size: CGSize) {
        self.init(
            origin: .zero,
            size: size
        )
    }

    func center() -> CGPoint {
        .init(
            x: midX,
            y: midY
        )
    }
}
