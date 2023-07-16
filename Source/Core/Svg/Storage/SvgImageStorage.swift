//
//  SvgImageStorage.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 12.07.2023.
//

import UIKit

protocol SvgImageStorageProtocol {
    func image(info: SvgImageInfo) -> UIImage?
    func save(image: UIImage, info: SvgImageInfo)
}

extension SvgImageStorage {
    typealias Info = SvgImageInfo
}

final class SvgImageStorage {
    private let manager = FileManager.default

    private let localDirectory: URL
    private let networkDirectory: URL

    private let imageScale = UIScreen.main.scale

    init() {
        let directory = manager
            .urls(
                for: .cachesDirectory,
                in: .userDomainMask
            )
            .first!.appendingPathComponent(.directory)

        localDirectory = directory.appendingPathComponent(.local)
        networkDirectory = directory.appendingPathComponent(.network)

        createDirectoriesIfNeeded()
    }

    private func createDirectoriesIfNeeded() {
        manager.createDirectoryIfRequired(url: localDirectory)
        manager.createDirectoryIfRequired(url: networkDirectory)
    }

    private func url(info: Info) -> URL {
        let directory: URL = info.name.isLocal()
            ? localDirectory
            : networkDirectory
        let component = info.pathComponent()
        return directory.appendingPathComponent(component)
    }

    private func image(url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return .init(data: data, scale: imageScale)
    }

    private func save(image: UIImage, url: URL) {
        try? image.pngData()?.write(to: url)
    }
}

extension SvgImageStorage: SvgImageStorageProtocol {
    func image(info: Info) -> UIImage? {
        let url = url(info: info)
        return image(url: url)
    }

    func save(image: UIImage, info: Info) {
        let url = url(info: info)
        save(image: image, url: url)
    }
}

// MARK: - Private
private extension SvgImageInfo {
    func pathComponent() -> String {
        let name: String
        switch self.name {
        case let .local(value):
            name = value.rawValue
        case let .network(icon):
            name = icon
        }
        let result = "\(name).\(height).\(String.extension)"
        return result
    }
}

// MARK: - Constants
private extension String {
    static let directory = "svgImages"
    static let `extension` = "png"
    static let local = "local"
    static let network = "network"
}
