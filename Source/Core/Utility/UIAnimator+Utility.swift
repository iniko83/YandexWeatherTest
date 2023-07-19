//
//  UIAnimator+Utility.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import UIKit

// NOTE: Define curve parameters - https://cubic-bezier.com

extension UIAnimator {
    typealias Animations = () -> Void
    typealias Animator = UIViewPropertyAnimator
    typealias Completion = () -> Void
    typealias Curve = UIView.AnimationCurve
    typealias PositionCompletion = (UIViewAnimatingPosition) -> Void
}

extension UIAnimator {
    enum Kind: Int {
        case color
        case indication
        case updateCollection

        func animator() -> Animator {
            let result: Animator
            switch self {
            case .color:
                result = .init(
                    duration: .color,
                    timingParameters: Parameters.color
                )

            case .indication:
                result = .init(
                    duration: .indication,
                    timingParameters: Parameters.indication
                )

            case .updateCollection:
                result = .init(
                    duration: .updateCollection,
                    timingParameters: Parameters.updateCollection
                )
            }
            return result
        }
    }
}

enum UIAnimator {

    static func animate(
        animated: Bool,
        kind: Kind,
        animations: @escaping Animations
    ) {
        if animated {
            let animator = make(with: kind, animations: animations)
            animator.startAnimation()
        } else {
            UIView.performWithoutAnimation(animations)
        }
    }

    static func animate(
        animated: Bool,
        kind: Kind,
        animations: @escaping Animations,
        completion: @escaping Completion
    ) {
        if animated {
            let animator = make(with: kind, animations: animations, completion: completion)
            animator.startAnimation()
        } else {
            animations()
            completion()
        }
    }

    static func animate(
        animated: Bool,
        kind: Kind,
        animations: @escaping Animations,
        positionCompletion: @escaping PositionCompletion
    ) {
        if animated {
            let animator = make(with: kind, animations: animations, positionCompletion: positionCompletion)
            animator.startAnimation()
        } else {
            UIView.performWithoutAnimation {
                animations()
                positionCompletion(.end)
            }
        }
    }

    static func animate(
        kind: Kind,
        animations: @escaping Animations
    ) {
        let animator = make(with: kind, animations: animations)
        animator.startAnimation()
    }

    static func animate(
        kind: Kind,
        animations: @escaping Animations,
        completion: @escaping Completion
    ) {
        let animator = make(with: kind, animations: animations, completion: completion)
        animator.startAnimation()
    }

    static func animate(
        kind: Kind,
        animations: @escaping Animations,
        positionCompletion: @escaping PositionCompletion
    ) {
        let animator = make(with: kind, animations: animations, positionCompletion: positionCompletion)
        animator.startAnimation()
    }

    // MARK: -
    static func make(kind: Kind) -> Animator {
        kind.animator()
    }

    static func make(
        with kind: Kind,
        animations: @escaping Animations
    ) -> Animator {
        let result = make(kind: kind)
        result.addAnimations(animations)
        return result
    }

    static func make(
        with kind: Kind,
        animations: @escaping Animations,
        completion: @escaping Completion
    ) -> Animator {
        let result = make(with: kind, animations: animations)
        result.addCompletion { _ in completion() }
        return result
    }

    static func make(
        with kind: Kind,
        animations: @escaping Animations,
        positionCompletion: @escaping PositionCompletion
    ) -> Animator {
        let result = make(with: kind, animations: animations)
        result.addCompletion(positionCompletion)
        return result
    }
}

private enum Parameters {
    static let color = UICubicTimingParameters(
        controlPoint1: .init(x: 0.25, y: 0.1),
        controlPoint2: .init(x: 0.25, y: 1)
    )

    static let indication = UICubicTimingParameters(
        controlPoint1: .init(x: 0.3, y: 0.43),
        controlPoint2: .init(x: 0.63, y: 1)
    )

    static let updateCollection = UICubicTimingParameters(animationCurve: .easeInOut)
}

private extension TimeInterval {
    static let color: TimeInterval = 0.25
    static let indication: TimeInterval = 0.4
    static let updateCollection: TimeInterval = 0.3
}
