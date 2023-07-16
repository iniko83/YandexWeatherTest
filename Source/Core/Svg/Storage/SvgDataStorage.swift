//
//  SvgDataStorage.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 12.07.2023.
//

import Foundation

protocol SvgDataStorageProtocol {
    func data(name: SvgImageName) -> Data?

    func save(_ data: Data, name: SvgImageName)
}

final class SvgDataStorage {
    private let manager = FileManager.default
    private let directory: URL

    init() {
        directory = manager
            .urls(
                for: .applicationSupportDirectory,
                in: .userDomainMask
            )
            .first!.appendingPathComponent(.directory)

        manager.createDirectoryIfRequired(url: directory)
    }

    private func data(name: String) -> Data? {
        try? .init(contentsOf: url(name))
    }

    private func data(name: SvgImageName.Local) -> Data? {
        guard
            let url = Bundle.main.url(
                forResource: name.rawValue,
                withExtension: .extension
            )
        else { return nil }

        return try? Data(contentsOf: url)
    }

    private func save(_ data: Data, name: String) {
        try! data.write(to: url(name))
    }

    private func url(_ name: String) -> URL {
        directory.appendingPathComponent(name)
    }
}

extension SvgDataStorage: SvgDataStorageProtocol {
    func data(name: SvgImageName) -> Data? {
        let result: Data?
        switch name {
        case let .local(name):
            result = data(name: name)
        case let .network(icon):
            result = data(name: icon)
        }
        return result
    }

    func save(_ data: Data, name: SvgImageName) {
        // save only downloaded (network, not local) data
        guard case let .network(icon) = name else { return }
        save(data, name: icon)
    }
}

// MARK: - Constants
private extension String {
    static let directory = "svgImages"
    static let `extension` = "svg"
}
