//
//  UICollectionView+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import UIKit

extension UICollectionView {
    final func dequeueReusableCell<T: UICollectionViewCell & ReuseIdentifiable>(_ type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }

    final func register<T: UICollectionViewCell & ReuseIdentifiable>(_ type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: type.reuseIdentifier)
    }

    final func registerNib<T: UICollectionViewCell & ReuseIdentifiable>(_ type: T.Type) {
        let id = type.reuseIdentifier
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellWithReuseIdentifier: id)
    }
}

extension UICollectionView {
    func cellIndexPaths() -> [IndexPath] {
        (0 ..< numberOfSections)
            .reduce(into: [IndexPath]()) { result, section in
                result += cellIndexPaths(inSection: section)
            }
    }

    func cellIndexPaths(inSection section: Int) -> [IndexPath] {
        (0 ..< numberOfItems(inSection: section))
            .reduce(into: [IndexPath]()) { result, item in
                let indexPath = IndexPath(item: item, section: section)
                result.append(indexPath)
            }
    }
}
