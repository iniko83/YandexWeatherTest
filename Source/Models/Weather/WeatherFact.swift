//
//  WeatherFact.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

// NOTE: https://yandex.ru/dev/weather/doc/dg/concepts/forecast-test.html

/* Здесь и далее можно было использовать JSONDecoder/JSONEncoder keyDecodingStrategy = .convertFromSnakeCase,
 но более осмысленное наименование полей читается лучше. Также это не работает с (enum SomeType: String) при кодогенерации.

    windGust                // Скорость порывов ветра, м/с
    season                  // Время года в данном населенном пункте
    obsTime                 // Время замера погодных данных в формате Unixtime (Int)
    isThunder               // Признак грозы
    precipitationType       // Тип осадков
    precipitationStrength   // Сила осадков
    cloudness               // Облачность
    phenomenonCondition     // Погодное явление (опционально)
    phenomenonIconAlias     // Иконка погодного явления (опционально)

 Иконка погодного явления доступна по адресу:
    https://yastatic.net/weather/i/icons/funky/dark/\(phenomenonIconAlias).svg
 */

enum Weather {}

extension Weather {
    struct Fact: Equatable {
        let baseInfo: BaseInfo
        let daytime: Daytime                             

        let windGust: CGFloat
        let season: Season
        let obsTime: Date
        let isThunder: Bool
        let precipitationType: PrecipitationType
        let precipitationStrength: Force
        let cloudness: Force
        let phenomenonCondition: PhenomenonCondition?
        let phenomenonIconAlias: String?
    }
}

extension Weather.Fact: Codable {
    private enum CodingKeys: String, CodingKey {
        case windGust               = "wind_gust"
        case season
        case obsTime                = "obs_time"
        case isThunder              = "is_thunder"
        case precipitationType      = "prec_type"
        case precipitationStrength  = "prec_strength"
        case cloudness
        case phenomenonCondition    = "phenom_condition"
        case phenomenonIconAlias    = "phenom_icon"
    }

    init(from decoder: Decoder) throws {
        baseInfo = try .init(from: decoder)
        daytime = try .init(from: decoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        windGust = try container.decode(CGFloat.self, forKey: .windGust)
        season = try container.decode(Weather.Season.self, forKey: .season)
        isThunder = try container.decode(Bool.self, forKey: .isThunder)
        precipitationType = try container.decode(PrecipitationType.self, forKey: .precipitationType)
        precipitationStrength = try container.decode(Weather.Force.self, forKey: .precipitationStrength)
        cloudness = try container.decode(Weather.Force.self, forKey: .cloudness)
        phenomenonCondition = try container.decodeIfPresent(Weather.PhenomenonCondition.self, forKey: .phenomenonCondition)
        phenomenonIconAlias = try container.decodeIfPresent(String.self, forKey: .phenomenonIconAlias)

        let obsTimeValue = try container.decode(Int.self, forKey: .obsTime)
        obsTime = .init(timeIntervalSince1970: TimeInterval(obsTimeValue))
    }

    func encode(to encoder: Encoder) throws {
        try baseInfo.encode(to: encoder)
        try daytime.encode(to: encoder)

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(windGust, forKey: .windGust)
        try container.encode(season, forKey: .season)
        try container.encode(isThunder, forKey: .isThunder)
        try container.encode(precipitationType, forKey: .precipitationType)
        try container.encode(precipitationStrength, forKey: .precipitationStrength)
        try container.encode(cloudness, forKey: .cloudness)
        try container.encodeIfPresent(phenomenonCondition, forKey: .phenomenonCondition)
        try container.encodeIfPresent(phenomenonIconAlias, forKey: .phenomenonIconAlias)

        let obsTimeValue = Int(obsTime.timeIntervalSince1970)
        try container.encode(obsTimeValue, forKey: .obsTime)
    }
}
