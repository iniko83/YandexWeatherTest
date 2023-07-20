//
//  EmptyState.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import Foundation

protocol EmptyIndicationViewProviderProtocol: IndicationViewProviderProtocol where
    Tag == EmptyState {}

struct EmptyState: Equatable {}
