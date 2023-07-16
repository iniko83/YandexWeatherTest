//
//  UIEdgeInsets+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 11.07.2023.
//

import UIKit

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
