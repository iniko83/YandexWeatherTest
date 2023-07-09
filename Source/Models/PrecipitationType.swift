//
//  PrecipitationType.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

enum PrecipitationType: String, Codable {
    case `none`     = "0"   // без осадков
    case rain       = "1"   // дождь
    case wetSnow    = "2"   // дождь со снегом
    case snow       = "3"   // снег
    case hail       = "4"   // град
}
