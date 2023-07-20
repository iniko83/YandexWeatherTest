//
//  IndicationLoadingView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 18.07.2023.
//

import UIKit

final class IndicationLoadingView: UIView {
    private let activityIndicatorView = ActivityIndicatorView()
    private let shimmerView = ShimmerView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(shimmerView)
        addSubview(activityIndicatorView)
    }

    // MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()

        shimmerView.frame = bounds

        layoutActivityIndicatorView()
    }

    private func layoutActivityIndicatorView() {
        let side = 0.5 * bounds.size.minimumSide()
        activityIndicatorView.frame = .init(
            center: bounds.center(),
            size: .init(side: side)
        )
    }
}

extension IndicationLoadingView: Connectable {
    func connect(_ model: Model) {
        activityIndicatorView.connect(model.activityIndicatorViewModel())
        shimmerView.connect(model.shimmerViewModel())
    }

    func disconnect() {
        activityIndicatorView.disconnect()
        shimmerView.disconnect()
    }
}

extension IndicationLoadingView {
    struct Model {
        let activityColor: UIColor
        let shimmerColor: UIColor

        fileprivate func activityIndicatorViewModel() -> ActivityIndicatorView.Model {
            .init(color: activityColor)
        }

        fileprivate func shimmerViewModel() -> ShimmerView.Model {
            .init(color: shimmerColor)
        }
    }
}
