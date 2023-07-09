//
//  WrongUrlError.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

struct WrongUrlError: Error {
    let baseUrl: URL
    let path: String
}
