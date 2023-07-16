//
//  NetworkAvailabilityInteractor.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 07.07.2023.
//

import Foundation
import Network

/* Пример интерактора без RxSwift, подписчики оповещаются посредством NotificationCenter **/

// NOTE: NWPathMonitor will not work via iOS Simulator

extension Notification.Name {
    static let didChangeNetworkAvailabilityStatus = Notification.Name("didChangeNetworkAvailabilityStatus")
}

final class NetworkAvailabilityInteractor {
    private var monitor: NWPathMonitor?

    private(set) var isNetworkAvailable = true {
        didSet {
            guard oldValue != isNetworkAvailable else { return }
            postNetworkAvailabilityNotification()
        }
    }

    private(set) var isObserving = false

    init() {
        setObserving(true)
    }

    deinit {
        setObserving(false)
    }

    private func postNetworkAvailabilityNotification() {
        NotificationCenter.default.post(name: .didChangeNetworkAvailabilityStatus, object: nil)
    }

    private func setObserving(_ observe: Bool) {
        isObserving = observe

        self.monitor?.cancel()

        guard observe else { return }

        let monitor = NWPathMonitor()
        self.monitor = monitor

        monitor.pathUpdateHandler = { [weak self] path in
            let isNetworkAvailable = path.status == .satisfied

            DispatchQueue.main.async {
                self?.isNetworkAvailable = isNetworkAvailable
            }
        }

        let gueue = DispatchQueue.global(qos: .background)
        monitor.start(queue: gueue)
    }
}
