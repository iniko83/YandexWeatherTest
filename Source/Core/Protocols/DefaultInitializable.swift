//
//  DefaultInitializable.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 07.07.2023.
//

import Foundation

typealias NibReusable = NibLoadable & ReuseIdentifiable

protocol DefaultInitializable {
    init()
}

extension BooleanLiteralType: DefaultInitializable {}
extension IntegerLiteralType: DefaultInitializable {}
extension StringLiteralType: DefaultInitializable {}

extension Array: DefaultInitializable {}

extension Date: DefaultInitializable {}

// MARK: - Model support
protocol Bindable: AnyObject {
    associatedtype Model

    func bind(_ model: Model)
}

protocol Connectable: Bindable {
    func connect(_ model: Model)
    func disconnect()
}

extension Connectable {
    func bind(_ model: Model) {
        disconnect()
        connect(model)
    }
}

// MARK: - Reusable support
protocol ReuseIdentifiable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        .init(describing: Self.self)
    }
}
