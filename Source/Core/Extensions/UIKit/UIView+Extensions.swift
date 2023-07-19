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
    final func snapToEdgesAndAddSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
