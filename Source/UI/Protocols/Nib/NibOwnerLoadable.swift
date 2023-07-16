//
//  NibOwnerLoadable.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 11.07.2023.
//

import UIKit

// NOTE: https://github.com/AliSoftware/Reusable

/// Make your UIView subclasses conform to this protocol when:
///  * they *are* NIB-based, and
///  * this class is used as the XIB's File's Owner
/// to be able to instantiate them from the NIB in a type-safe manner

protocol NibOwnerLoadable: AnyObject {}

extension NibOwnerLoadable where Self: UIView {
    /**
     Adds content loaded from the nib to the end of the receiver's list of subviews and adds constraints automatically.
     */
    func loadNibContent() {
        let nib = UINib(
            nibName: String(describing: Self.self),
            bundle: Bundle(for: Self.self)
        )

        let layoutAttributes: [NSLayoutConstraint.Attribute] = [
            .top,
            .leading,
            .bottom,
            .trailing
        ]

        let list = nib.instantiate(withOwner: self, options: nil)
        for case let view as UIView in list {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)

            let constraints = layoutAttributes.map { attribute in
                NSLayoutConstraint(
                    item: view,
                    attribute: attribute,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: attribute,
                    multiplier: 1,
                    constant: 0.0
                )
            }
            NSLayoutConstraint.activate(constraints)
        }
    }
}
