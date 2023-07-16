//
//  SvgImageCache.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 13.07.2023.
//

import UIKit

extension SvgImageCache {
    typealias Info = SvgImageInfo
}

final class SvgImageCache {
    private var items = [Info: UIImage]()

    subscript(info: Info) -> UIImage? {
        get {
            items[info]
        }
        set {
            items[info] = newValue
        }
    }

    init() {
        observeMemoryWarnings(true)
    }

    deinit {
        observeMemoryWarnings(false)
    }

    // MARK: - Subscription support
    private func observeMemoryWarnings(_ isObserve: Bool) {
        let notificationCenter = NotificationCenter.default
        let name = UIApplication.didReceiveMemoryWarningNotification
        if isObserve {
            notificationCenter.addObserver(
                self,
                selector: #selector(onReceiveMemoryWarning),
                name: name,
                object: nil
            )
        } else {
            notificationCenter.removeObserver(
                self,
                name: name,
                object: nil
            )
        }
    }

    @objc
    private func onReceiveMemoryWarning() {
        items = .init()
    }
}
