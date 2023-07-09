//
//  ApiResponse+Rx.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == ApiResponse {
    func map<Object: Decodable>(_ type: Object.Type) -> Single<Object> {
        flatMap { element in .just(try element.map(type)) }
    }

    func mapOptional<Object: Decodable>(_ type: Object.Type) -> Single<Object?> {
        flatMap { element in .just(try? element.map(type)) }
    }
}
