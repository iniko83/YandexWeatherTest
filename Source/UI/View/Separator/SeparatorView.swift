//
//  SeparatorView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 20.07.2023.
//

import UIKit

final class SeparatorView: UIView {
    override var intrinsicContentSize: CGSize {
        .noIntrinsic(height: .height)
    }
}

// MARK: - Constants
private extension CGFloat {
    static let height = 1 / UIScreen.main.scale
}
