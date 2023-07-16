//
//  NibLoadable.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 11.07.2023.
//

import UIKit

// NOTE: https://github.com/AliSoftware/Reusable

/// Make your UIView subclasses conform to this protocol when:
///     * they *are* NIB-based, and
///     * this class is used as the XIB's root view
/// to be able to instantiate them from the NIB in a type-safe manner
///

protocol NibLoadable: AnyObject {}

extension NibLoadable where Self: UIView {
    /**
     Returns a `UIView` object instantiated from nib

     - returns: A `UIView: NibLoadable` instance
     */
    static func loadFromNib() -> Self {
        let nib = UINib(
            nibName: String(describing: self),
            bundle: Bundle(for: self)
        )

        guard let result = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }

        return result
    }
}
