//
//  WeatherForecastView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 14.07.2023.
//

import UIKit

@IBDesignable
final class WeatherForecastView: UIView, NibOwnerLoadable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        loadNibContent()
    }
}
