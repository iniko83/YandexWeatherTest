//
//  WeatherCondition.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

extension Weather {
    enum Condition: String, Codable {
        case clear                                              // ясно
        case partlyCloudy = "partly-cloudy"                     // малооблачно.
        case cloudy                                             // облачно с прояснениями.
        case overcast                                           // пасмурно
        case lightRain = "light-rain"                           // небольшой дождь
        case rain                                               // дождь
        case heavyRain = "heavy-rain"                           // сильный дождь
        case showers                                            // ливень
        case wetSnow = "wet-snow"                               // дождь со снегом
        case lightSnow = "light-snow"                           // небольшой снег
        case snow                                               // снег
        case snowShowers = "snow-showers"                       // снегопад
        case hail                                               // град
        case thunderstorm                                       // гроза
        case thunderstormWithRain = "thunderstorm-with-rain"    // дождь с грозой
        case thunderstormWithHail = "thunderstorm-with-hail"    // гроза с градом
    }
}
