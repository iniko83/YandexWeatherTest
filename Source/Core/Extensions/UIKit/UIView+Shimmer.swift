//
//  UIView+Shimmer.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 18.07.2023.
//

import UIKit

// NOTE: Based on - https://antonio081014.medium.com/howto-add-shimmering-animation-effect-to-uiview-9f56ffc75c47

protocol SupportShimmering: AnyObject {
    var shimmerLayer: CAGradientLayer { get }
}

extension SupportShimmering {
    var isShimmering: Bool {
        get {
            shimmerLayer.animation(forKey: .shimmer) != nil
        }
    }

    func updateShimmerLayerFrame(_ bounds: CGRect) {
        shimmerLayer.frame = .init(
            x: -bounds.width,
            y: 0,
            width: 3 * bounds.width,
            height: bounds.height
        )
    }
}

extension SupportShimmering where Self: UIView {
    func startShimmering() {
        layer.mask = shimmerLayer

        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.25
        animation.repeatCount = .infinity
        shimmerLayer.add(animation, forKey: .shimmer)
    }

    func stopShimmering() {
        layer.mask = nil
        shimmerLayer.removeAnimation(forKey: .shimmer)
    }
}

// MARK: - Constants
private extension String {
    static let shimmer = "shimmer"
}
