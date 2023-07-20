//
//  UIScrollView+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 20.07.2023.
//

import UIKit

// NOTE: https://stackoverflow.com/a/75620987

extension UIScrollView {
    final func change(contentInset value: UIEdgeInsets) {
        let offset = contentOffset
        contentInset = value
        contentOffset = offset
    }

    final func update(contentInset value: UIEdgeInsets) {
        guard contentInset != value else { return }
        change(contentInset: value)
    }
}
