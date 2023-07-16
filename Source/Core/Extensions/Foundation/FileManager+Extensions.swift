//
//  FileManager+Extensions.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 13.07.2023.
//

import Foundation

extension FileManager {
    func createDirectoryIfRequired(path: String) {
        guard !fileExists(atPath: path) else { return }
        try! createDirectory(atPath: path, withIntermediateDirectories: true)
    }

    func createDirectoryIfRequired(url: URL) {
        createDirectoryIfRequired(path: url.path)
    }
}
