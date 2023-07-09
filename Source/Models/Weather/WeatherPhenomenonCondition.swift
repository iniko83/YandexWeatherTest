//
//  WeatherPhenomenonCondition.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

extension Weather {
    enum PhenomenonCondition: String, Codable {
        case fog                                                        // туман
        case mist                                                       // дымка
        case smoke                                                      // смог
        case dust                                                       // пыль
        case dustSuspension = "dust-suspension"                         // пылевая взвесь
        case duststorm                                                  // пыльная буря
        case thunderstormWithDuststorm = "thunderstorm-with-duststorm"  // пыльная буря с грозой
        case driftingSnow = "drifting-snow"                             // слабая метель
        case blowingSnow = "blowing-snow"                               // метель
        case icePellets = "ice-pellets"                                 // ледяная крупа
        case freezingRain = "freezing-rain"                             // ледяной дождь
        case tornado                                                    // торнадо
        case volcanicAsh = "volcanic-ash"                               // вулканический пепел
    }
}
