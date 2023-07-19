//
//  ShimmerView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 18.07.2023.
//

import UIKit

final class ShimmerView: UIView, SupportShimmering {
    let shimmerLayer = CAGradientLayer.makeShimmerLayer()

    private var shimmerBounds = CGRect.zero

    override func layoutSubviews() {
        super.layoutSubviews()

        updateShimmerLayerFrameIfNeeded()
    }

    private func updateShimmerLayerFrameIfNeeded() {
        guard shimmerBounds != bounds else { return }

        shimmerBounds = bounds
        updateShimmerLayerFrame(bounds)
    }
}

extension ShimmerView: Connectable {
    typealias Model = ActivityIndicatorView.Model

    func connect(_ model: ActivityIndicatorView.Model) {
        backgroundColor = model.color

        startShimmering()
    }

    func disconnect() {
        backgroundColor = nil

        stopShimmering()
    }
}
