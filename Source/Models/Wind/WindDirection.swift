//
//  WindDirection.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 09.07.2023.
//

import Foundation

extension Wind {
    enum Direction: String, Codable, Equatable {
        case northWest  = "nw"
        case north      = "n"
        case northEast  = "ne"
        case east       = "e"
        case southEast  = "se"
        case south      = "s"
        case southWest  = "sw"
        case west       = "w"
        case calm       = "c"

        func isCalm() -> Bool {
            self == .calm
        }

        func rotation() -> CGFloat {
            0.25 * CGFloat(rotationPart()) * .pi
        }

        func shortText() -> String {
            let result: String
            switch self {
            case .northWest:
                result = L10n.Wind.Direction.Short.northWest
            case .north:
                result = L10n.Wind.Direction.Short.north
            case .northEast:
                result = L10n.Wind.Direction.Short.northEast
            case .east:
                result = L10n.Wind.Direction.Short.east
            case .southEast:
                result = L10n.Wind.Direction.Short.southEast
            case .south:
                result = L10n.Wind.Direction.Short.south
            case .southWest:
                result = L10n.Wind.Direction.Short.southWest
            case .west:
                result = L10n.Wind.Direction.Short.west
            case .calm:
                result = L10n.Wind.Direction.Short.calm
            }
            return result
        }

        // MARK: - Private
        private func rotationPart() -> Int {
            let result: Int
            switch self {
            case .northWest:
                result = 7
            case .north:
                result = 0
            case .northEast:
                result = 1
            case .east:
                result = 2
            case .southEast:
                result = 3
            case .south:
                result = 4
            case .southWest:
                result = 5
            case .west:
                result = 6
            case .calm:
                result = 0
            }
            return result
        }
    }
}

extension Wind.Direction: DefaultInitializable {
    init() {
        self = .calm
    }
}
