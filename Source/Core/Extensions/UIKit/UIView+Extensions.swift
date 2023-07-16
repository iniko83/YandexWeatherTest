//
//  UIView+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 12.07.2023.
//

import UIKit

extension UIView {
    func snapshotImage() -> UIImage {
        UIGraphicsImageRenderer(size: bounds.size)
            .image { _ in
                self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            }
    }
}
