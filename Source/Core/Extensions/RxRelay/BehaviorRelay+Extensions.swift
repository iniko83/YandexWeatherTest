//
//  BehaviorRelay+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 07.07.2023.
//

import RxRelay

extension BehaviorRelay where Element: Equatable {
    func acceptDifferent(_ event: Element) {
        guard event != value else { return }
        accept(event)
    }
}

// MARK: -
extension BehaviorRelay where Element: DefaultInitializable {
    convenience init() {
        self.init(value: .init())
    }
}

extension BehaviorRelay where Element: ExpressibleByBooleanLiteral {
    convenience init() {
        self.init(value: false)
    }
}

extension BehaviorRelay where Element: ExpressibleByNilLiteral {
    convenience init() {
        self.init(value: nil)
    }
}
