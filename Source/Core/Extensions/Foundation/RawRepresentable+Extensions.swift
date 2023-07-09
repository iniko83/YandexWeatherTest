//
//  RawRepresentable+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

extension RawRepresentable where RawValue: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue > rhs.rawValue
    }

    static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue <= rhs.rawValue
    }

    static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue >= rhs.rawValue
    }
}
