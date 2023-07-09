//
//  HttpMethod.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

enum HttpMethod: Int {
    case get

    func string() -> String {
        "GET"
    }
}
