//
//  PrecipitationType.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

enum PrecipitationType: Int, Codable {
    case `none`     // без осадков
    case rain       // дождь
    case wetSnow    // дождь со снегом
    case snow       // снег
    case hail       // град
}
