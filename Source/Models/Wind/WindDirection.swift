//
//  WindDirection.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

extension Wind {
    enum Direction: String, Codable {
        case northWest  = "nw"  // северо-западное
        case north      = "n"   // северное
        case northEast  = "ne"  // северо-восточное
        case east       = "e"   // восточное
        case eastSouth  = "se"  // юго-восточное
        case south      = "s"   // южное
        case southWest  = "sw"  // юго-западное
        case west       = "w"   // западное
        case calm       = "c"   // штиль
    }
}
