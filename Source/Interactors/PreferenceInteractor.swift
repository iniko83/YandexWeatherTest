//
//  PreferenceInteractor.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 07.07.2023.
//

import Foundation

final class PreferenceInteractor {
    let userDefaults = UserDefaults.standard

    // TODO: - кэширование моделей
    /* чтобы не грузить с сервера (ограничение на 50 запросов в сутки, отталкиваемся от
     места локации (+/- дистанция)  + времени (не чаще предыдущего +10 минут)).
     */
}
