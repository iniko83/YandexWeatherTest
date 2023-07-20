//
//  WeatherBaseInfoHeaderView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import UIKit

@IBDesignable
final class WeatherBaseInfoHeaderView: UIView, NibOwnerLoadable {
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var humidityIconView: SvgImageView!
    @IBOutlet private weak var windIconView: SvgImageView!

    override var intrinsicContentSize: CGSize {
        .noIntrinsic(height: .height)
    }

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
        configureViews()
    }

    private func bindIconViews() {
        humidityIconView.bind(
            .init(
                name: .local(.humidity),
                isTemplate: true
            )
        )

        windIconView.bind(
            .init(
                name: .local(.wind),
                isTemplate: true
            )
        )
    }

    private func configureViews() {
        temperatureLabel.text = L10n.Weather.BaseInfo.HeaderTitle.temperature
        feelsLikeLabel.text = L10n.Weather.BaseInfo.HeaderTitle.feelsLike
        pressureLabel.text = L10n.Weather.BaseInfo.HeaderTitle.pressure

        bindIconViews()
    }
}

extension WeatherBaseInfoHeaderView: Connectable {
    typealias Model = ActivityIndicatorView.Model

    func connect(_ model: Model) {
        updateData(model)
    }

    func disconnect() {
        updateData(nil)
    }

    private func updateData(_ model: Model?) {
        let color = model?.color ?? .clear

        temperatureLabel.textColor = color
        feelsLikeLabel.textColor = color
        pressureLabel.textColor = color

        humidityIconView.tintColor = color
        windIconView.tintColor = color
    }
}

// MARK: - Constants
private extension CGFloat {
    static let height: CGFloat = 44
}
