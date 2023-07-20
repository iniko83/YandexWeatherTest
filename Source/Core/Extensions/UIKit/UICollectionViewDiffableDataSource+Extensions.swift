//
//  UICollectionViewDiffableDataSource+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import UIKit

extension UICollectionViewDiffableDataSource {
    final func item(at indexPath: IndexPath) -> ItemIdentifierType {
        itemIdentifier(for: indexPath)!
    }
}
