//
//  UIAlertController+Utility.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 17.07.2023.
//

import UIKit

extension UIAlertController.Action {
    typealias Handler = () -> Void
}

extension UIAlertController {
    struct Action {
        let title: String
        let style: UIAlertAction.Style
        let handler: Handler

        func action() -> UIAlertAction {
            .init(
                title: title,
                style: style,
                handler: { _ in self.handler() }
            )
        }
    }
}

extension UIAlertController.Action {
    static func `default`(
        _ title: String,
        handler: @escaping Handler
    ) -> Self {
        .init(
            title: title,
            style: .default,
            handler: handler
        )
    }

    static func destructive(
        _ title: String,
        handler: @escaping Handler
    ) -> Self {
        .init(
            title: title,
            style: .destructive,
            handler: handler
        )
    }

    static func cancel(
        _ title: String = L10n.Action.Cancel.verb,
        handler: @escaping Handler = {}
    ) -> Self {
        .init(
            title: title,
            style: .cancel,
            handler: handler
        )
    }
}

extension UIAlertController {
    static func make(
        title: String? = nil,
        message: String? = nil,
        style: UIAlertController.Style = .alert,
        actions: [Action]
    ) -> Self {
        let result = Self(
            title: title,
            message: message,
            preferredStyle: style
        )

        for action in actions {
            result.addAction(action.action())
        }

        return result
    }
}
