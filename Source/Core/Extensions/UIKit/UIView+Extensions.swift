//
//  UIView+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 12.07.2023.
//

import UIKit

extension UIView {
    final func snapshotImage() -> UIImage {
        UIGraphicsImageRenderer(size: bounds.size)
            .image { _ in
                self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            }
    }
}

extension UIView {
    /* Return order: centerX, centerY. **/
    final func makeCenterConstraints(subview: UIView) -> [NSLayoutConstraint] {
        [
            subview.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
        ]
    }

    /* Return order: leading, trailing, top, bottom. **/
    final func makeEdgeConstraints(subview: UIView) -> [NSLayoutConstraint] {
        [
            subview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: subview.trailingAnchor),
            subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: subview.bottomAnchor)
        ]
    }

    final func makeEdgeConstraints(
        subview: UIView,
        insets: NSDirectionalEdgeInsets
    ) -> [NSLayoutConstraint] {
        [
            subview.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: insets.leading
            ),
            safeAreaLayoutGuide.trailingAnchor.constraint(
                equalTo: subview.trailingAnchor,
                constant: insets.trailing
            ),
            subview.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: insets.top
            ),
            safeAreaLayoutGuide.bottomAnchor.constraint(
                equalTo: subview.bottomAnchor,
                constant: insets.bottom
            )
        ]
    }

    final func makeEdgeConstraints(
        subview: UIView,
        insets: NSDirectionalEdgeInsets,
        priority: UILayoutPriority
    ) -> [NSLayoutConstraint] {
        let result = makeEdgeConstraints(subview: subview, insets: insets)
        result.forEach { constraint in constraint.priority = priority }
        return result
    }
}

extension UIView {
    final func snapToEdgesAndAddSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        let constraints = makeEdgeConstraints(subview: view)
        NSLayoutConstraint.activate(constraints)
    }
}
