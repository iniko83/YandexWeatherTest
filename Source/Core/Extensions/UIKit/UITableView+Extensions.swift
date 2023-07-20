//
//  UITableView+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import UIKit

extension UITableView {
    final func dequeueReusableCell<T: UITableViewCell & ReuseIdentifiable>(_ type: T.Type) -> T {
        dequeueReusableCell(withIdentifier: type.reuseIdentifier) as! T
    }

    final func dequeueReusableCell<T: UITableViewCell & ReuseIdentifiable>(_ type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as! T
    }

    final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) as! T
    }

    final func register<T: UITableViewCell & ReuseIdentifiable>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: type.reuseIdentifier)
    }

    final func register<T: UITableViewHeaderFooterView & ReuseIdentifiable>(_ type: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }

    final func registerNib<T: UITableViewCell & NibReusable>(_ type: T.Type) {
        let id = type.reuseIdentifier
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellReuseIdentifier: id)
    }

    final func registerNib<T: UITableViewHeaderFooterView & NibReusable>(_ type: T.Type) {
        let id = type.reuseIdentifier
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: id)
    }
}

extension UITableView {
    class func make() -> Self {
        let result = Self()
        result.configureDefaultStyle()
        result.disableHeaderTopPadding()
        result.hideFillerRows()
        result.estimatedRowHeight = UITableView.automaticDimension
        return result
    }
}

extension UITableView {
    final func configureDefaultStyle() {
        backgroundColor = .clear
        separatorStyle = .none
    }

    final func disableHeaderTopPadding() {
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
    }

    final func hideFillerRows() {
        if #available(iOS 15.0, *) {
            fillerRowHeight = 0
        } else {
            tableFooterView = .init()
        }
    }
}
