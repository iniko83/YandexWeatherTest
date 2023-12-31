//
//  SvgImageView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 13.07.2023.
//

import Resolver
import RxSwift

extension SvgImageView {
    typealias ImageProvider = SvgImageProviderInteractor

    typealias Info = SvgImageInfo
    typealias Name = SvgImageName
}

/* Отображает svg image, запрашивая нужный размер при изменении bounds (если в модели не указано иное). **/
final class SvgImageView: UIImageView {
    private var bag = DisposeBag()
    private var delayBag = DisposeBag()
    private var model: Model?

    private let imageProvider: ImageProvider = Resolver.resolve()

    private weak var activityIndicationView: ActivityIndicatorView?
    private var isActivityPrepareToShowing = false

    private var fetchStartTimestamp = TimeInterval.zero
    private var fetchFinishTimestamp = TimeInterval.zero

    private var isDisplayingPlaceholderImage = false
    private var isObserveNetworkAvailability = false

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutActivityIndicatorView()

        fetchImageByLayoutIfRequired()
    }

    private func layoutActivityIndicatorView() {
        guard let view = activityIndicationView else { return }
        let side = 0.5 * bounds.size.minimumSide()
        view.frame = .init(
            center: bounds.center(),
            size: .init(side: side)
        )
    }

    private func fetchImage(isPlaceholder: Bool = false) {
        guard let model else { return }

        let name: Name = isPlaceholder
            ? .noImage
            : model.name
        let height = model.requestSize.fetchHeight(bounds.height)
        let info = Info(name: name, height: height)

        bag = .init()

        fetchStartTimestamp = Date.currentTimestamp()

        showActivity()

        imageProvider
            .fetchImage(info: info)
            .subscribe(
                onSuccess: { [unowned self] image in
                    self.onReceiveImage(image, isPlaceholder: isPlaceholder)
                },
                onFailure: { [unowned self] error in
                    if isPlaceholder {
                        self.image = nil
                    } else {
                        self.fetchImage(isPlaceholder: true)
                    }
                }
            )
            .disposed(by: bag)
    }

    private func fetchImageByLayoutIfRequired() {
        guard
            let model,
            let image
        else { return }

        let currentHeight = Int(image.size.height)
        let requredHeight = model.requestSize.fetchHeight(bounds.height)

        guard currentHeight != requredHeight else { return }

        fetchImage(isPlaceholder: isDisplayingPlaceholderImage)
    }

    private func isFetchProcessWasQuick() -> Bool {
        let value = fetchFinishTimestamp - fetchStartTimestamp
        let result = value > .fetchTransitionThreshold
        return result
    }

    private func isNeedObserveNetworkAvailability() -> Bool {
        guard let model else { return false }

        return isDisplayingPlaceholderImage
            && model.name.isLocal()
    }

    private func onReceiveImage(
        _ receivedImage: UIImage,
        isPlaceholder: Bool
    ) {
        hideActivity()

        guard let model else { return }

        isDisplayingPlaceholderImage = isPlaceholder
        fetchFinishTimestamp = Date.currentTimestamp()

        let image = model.isTemplate
            ? receivedImage.withRenderingMode(.alwaysTemplate)
            : receivedImage

        let isAnimateTransition = isFetchProcessWasQuick()
        if isAnimateTransition {
            UIView.transition(
                with: self,
                duration: .transition,
                options: .transitionCrossDissolve,
                animations: { self.image = image },
                completion: nil
            )
        } else {
            self.image = image
        }

        setNeedsLayout()

        let isObserve = isNeedObserveNetworkAvailability()
        observeNetworkAvailability(isObserve)
    }

    // MARK: - Activity support
    private func hideActivity() {
        isActivityPrepareToShowing = false
        delayBag = .init()
        activityIndicationView?.removeFromSuperview()
    }

    private func showActivity() {
        guard !isActivityPrepareToShowing else { return }

        isActivityPrepareToShowing = true

        delayBag = .init()

        Observable
            .just(Void())
            .delaySubscription(.activityDelay, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in self.presentActivity() })
            .disposed(by: delayBag)
    }

    private func presentActivity() {
        let model = ActivityIndicatorView.Model(color: Asset.Assets.activity.color)
        let activityIndicatorView = ActivityIndicatorView()
        activityIndicatorView.connect(model)
        addSubview(activityIndicatorView)

        self.activityIndicationView = activityIndicatorView

        setNeedsLayout()
    }

    // MARK: - Subscription support
    private func observeNetworkAvailability(_ isObserve: Bool) {
        guard isObserveNetworkAvailability != isObserve else { return }
        isObserveNetworkAvailability = isObserve

        let notificationCenter = NotificationCenter.default
        let name = Notification.Name.didChangeNetworkAvailabilityStatus
        if isObserve {
            notificationCenter.addObserver(
                self,
                selector: #selector(onChangeNetworkAvailability),
                name: name,
                object: nil
            )
        } else {
            notificationCenter.removeObserver(
                self,
                name: name,
                object: nil
            )
        }
    }

    @objc
    private func onChangeNetworkAvailability() {
        guard isNetworkAvailable() else { return }
        fetchImage()
    }

    private func isNetworkAvailable() -> Bool {
        let interactor: NetworkAvailabilityInteractor = Resolver.resolve()
        return interactor.isNetworkAvailable
    }
}

extension SvgImageView: Connectable {
    struct Model {
        let name: Name
        let isTemplate: Bool
        let requestSize: RequestSize
    }

    func connect(_ model: Model) {
        updateData(model)

        fetchImage()
    }

    func disconnect() {
        observeNetworkAvailability(false)

        bag = .init()

        updateData(nil)
    }

    private func updateData(_ model: Model?) {
        self.model = model

        guard model == nil else { return }

        image = nil
        isDisplayingPlaceholderImage = false
    }
}

extension SvgImageView {
    enum RequestSize {
        case height(Int)
        case selfSizing

        func fetchHeight(_ viewHeight: CGFloat) -> Int {
            let result: Int
            switch self {
            case let .height(value):
                result = value
            case .selfSizing:
                result = Int(viewHeight)
            }
            return result
        }
    }
}

extension SvgImageView.Model {
    init(name: SvgImageName) {
        self.init(
            name: name,
            isTemplate: false
        )
    }

    init(
        name: SvgImageName,
        isTemplate: Bool
    ) {
        self.init(
            name: name,
            isTemplate: isTemplate,
            requestSize: .selfSizing
        )
    }
}

// MARK: - Constants
private extension TimeInterval {
    static let fetchTransitionThreshold = 0.15
    static let transition = 0.3
}

// MARK: - Constants
private extension RxTimeInterval {
    static let activityDelay = RxTimeInterval.timeInterval(0.1)
}
