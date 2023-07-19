//
//  RxTimeInterval+Utility.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import RxSwift

extension RxTimeInterval {
    static let zero = RxTimeInterval.milliseconds(0)

    static func timeInterval(_ interval: TimeInterval) -> RxTimeInterval {
        .milliseconds(Int(interval * 1000))
    }
}
