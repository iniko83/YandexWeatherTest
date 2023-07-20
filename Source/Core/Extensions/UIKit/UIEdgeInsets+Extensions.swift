//
//  UIEdgeInsets+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 11.07.2023.
//

import UIKit

extension UIEdgeInsets {
    init(
        left: CGFloat,
        right: CGFloat
    ) {
        self.init(
            top: .zero,
            left: left,
            bottom: .zero,
            right: right
        )
    }

    init(
        top: CGFloat,
        bottom: CGFloat
    ) {
        self.init(
            top: top,
            left: .zero,
            bottom: bottom,
            right: .zero
        )
    }
}

extension UIEdgeInsets {
    init(horizontal: CGFloat) {
        self.init(
            left: horizontal,
            right: horizontal
        )
    }

    init(vertical: CGFloat) {
        self.init(
            top: vertical,
            bottom: vertical
        )
    }
}

extension UIEdgeInsets {
    func height() -> CGFloat {
        top + bottom
    }

    func width() -> CGFloat {
        left + right
    }

    func origin() -> CGPoint {
        .init(x: left, y: top)
    }
}
