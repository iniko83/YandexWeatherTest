//
//  ActivityIndicatorView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 18.07.2023.
//

import UIKit

// NOTE: Based on: https://github.com/ninjaprox/NVActivityIndicatorView

final class ActivityIndicatorView: UIView {
    private let activityLayer = CAShapeLayer()

    private var layerSide = CGFloat.zero

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
        setupActivityLayer()
    }

    private func setupActivityLayer() {
        activityLayer.backgroundColor = nil
        activityLayer.fillColor = nil
        activityLayer.lineCap = .round
        activityLayer.lineJoin = .bevel

        layer.addSublayer(activityLayer)
    }

    // MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayerDimensionsIfNeeded()
    }

    // MARK: -
    private func shapePath(radius: CGFloat) -> CGPath {
        let path: UIBezierPath = UIBezierPath()
        path.addArc(
            withCenter: .zero,
            radius: radius,
            startAngle: -0.5 * .pi,
            endAngle: 1.5 * .pi,
            clockwise: true
        )
        return path.cgPath
    }

    private func updateLayerDimensionsIfNeeded() {
        let side = bounds.size.minimumSide()

        guard layerSide != side else { return }

        layerSide = side

        let center = bounds.center()
        let lineWidth = 0.1 * side
        let radius = 0.45 * side

        let layer = activityLayer
        layer.lineWidth = lineWidth
        layer.path = shapePath(radius: radius)
        layer.bounds = .init(center: .zero, size: .init(side: side))
        layer.position = center
    }

    // MARK: - Animations support
    private func activityAnimation() -> CAAnimation {
        let beginTime: Double = 0.5
        let strokeStartDuration: Double = 1.2
        let strokeEndDuration: Double = 0.7
        let strokeTimingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0, 0.2, 1)

        let rotationAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        rotationAnimation.valueFunction = .init(name: .rotateZ)
        rotationAnimation.timingFunction = .init(name: .linear)
        rotationAnimation.byValue = Float.pi * 2

        let strokeEndAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        strokeEndAnimation.duration = strokeEndDuration
        strokeEndAnimation.timingFunction = strokeTimingFunction
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1

        let strokeStartAnimation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeStart))
        strokeStartAnimation.duration = strokeStartDuration
        strokeStartAnimation.timingFunction = strokeTimingFunction
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.beginTime = beginTime

        let result = CAAnimationGroup()
        result.animations = [
            rotationAnimation,
            strokeEndAnimation,
            strokeStartAnimation
        ]
        result.duration = strokeStartDuration + beginTime
        result.repeatCount = .infinity
        result.isRemovedOnCompletion = false
        result.fillMode = .forwards

        return result
    }

    @objc
    private func startAnimation() {
        let animation = activityAnimation()
        activityLayer.add(animation, forKey: .activity)
    }

    @objc
    private func stopAnimation() {
        activityLayer.removeAnimation(forKey: .activity)
    }
}

extension ActivityIndicatorView: Connectable {
    struct Model {
        let color: UIColor
    }

    func connect(_ model: Model) {
        activityLayer.strokeColor = model.color.cgColor

        startAnimation()
    }

    func disconnect() {
        stopAnimation()
    }
}

// MARK: - Constants
private extension String {
    static let activity = "activity"
}
