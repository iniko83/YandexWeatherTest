//
//  SvgImageLoaderInteractor.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 12.07.2023.
//

import RxSwift

protocol SvgImageProviderInteractorProtocol {
    func fetchImage(info: SvgImageInfo) -> Single<UIImage>
}

extension SvgImageProviderInteractor {
    typealias DataLoader = SvgDataLoader
    typealias DataStorage = SvgDataStorage
    typealias ImageCache = SvgImageCache
    typealias ImageRenderer = SvgImageRenderer
    typealias ImageStorage = SvgImageStorage

    typealias Info = SvgImageInfo
    typealias LocalName = Name.Local
    typealias Name = SvgImageName
}

final class SvgImageProviderInteractor {
    private let dataLoader: DataLoader
    private let dataStorage: DataStorage
    private let imageCache: ImageCache
    private let imageRenderer: ImageRenderer
    private let imageStorage: ImageStorage

    init() {
        dataLoader = .init()
        dataStorage = .init()
        imageCache = .init()
        imageRenderer = .init()
        imageStorage = .init()
    }

    private func fetchImageData(name: Name) -> Single<Data> {
        let result: Single<Data>
        if let data = dataStorage.data(name: name) {
            result = .just(data)
        } else {
            switch name {
            case let .local(name):
                let error = SvgImageResourceError(name: name)
                result = .error(error)

            case let .network(icon):
                result = loadImageData(icon: icon)
                    .do(onSuccess: { [unowned self] data in
                        self.dataStorage.save(data, name: name)
                    })
            }
        }
        return result
    }

    private func fetchStorageImage(info: Info) -> Single<UIImage> {
        let result: Single<UIImage>
        if let image = imageStorage.image(info: info) {
            result = .just(image)
        } else {
            result = renderImage(info: info)
                .do(onSuccess: { [unowned self] image in
                    self.imageStorage.save(image: image, info: info)
                })
        }
        return result
    }

    private func loadImageData(icon: String) -> Single<Data> {
        dataLoader.loadSvgData(icon: icon)
    }

    private func renderImage(info: Info) -> Single<UIImage> {
        fetchImageData(name: info.name)
            .flatMap { [unowned self] data in
                self.imageRenderer.renderSvgImage(info: info, data: data)
            }
    }
}

extension SvgImageProviderInteractor: SvgImageProviderInteractorProtocol {
    func fetchImage(info: Info) -> Single<UIImage> {
        let result: Single<UIImage>
        if let image = imageCache[info] {
            result = .just(image)
        } else {
            result = fetchStorageImage(info: info)
                .do(onSuccess: { [unowned self] image in
                    self.imageCache[info] = image
                })
        }
        return result
    }
}
