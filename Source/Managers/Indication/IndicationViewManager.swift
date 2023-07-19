//
//  IndicationViewManager.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 18.07.2023.
//

import RxRelay
import RxSwift

protocol IndicationViewProviderProtocol: AnyObject {
    associatedtype Tag: Equatable

    func indicationView(_ tag: Tag) -> UIView
}

extension IndicationViewManager {
    typealias Tag = Provider.Tag
}

final class IndicationViewManager<Provider: IndicationViewProviderProtocol> {
    private var bag = DisposeBag()
    private var delayBag = DisposeBag()
    private var modelBag: DisposeBag?

    private var provider: Provider?

    private weak var containerView: UIView?
    private weak var hideableContentView: UIView?

    private weak var stateView: UIView?

    private var indicationDelay = RxTimeInterval.zero

    var animated = false

    private func display(tag: Tag?) {
        guard let containerView else { return }

        let nextView: UIView?
        if let tag, let view = provider?.indicationView(tag) {
            nextView = view
        } else {
            nextView = nil
        }

        guard nextView !== stateView else { return }

        let previousView = stateView
        stateView = nextView

        if let view = nextView, view.superview == nil {
            view.alpha = 0

            containerView.snapToEdgesAndAddSubview(view)

            if containerView.isHidden {
                containerView.alpha = 0
                containerView.isHidden = false
            }
        }

        if stateView == nil {
            hideableContentView?.isHidden = false
        }

        let animations = {
            previousView?.alpha = 0
            self.stateView?.alpha = 1

            let isContentHidden = self.stateView != nil
            containerView.alpha = isContentHidden ? 1 : 0
            self.hideableContentView?.alpha = isContentHidden ? 0 : 1
        }
        let completion = { [weak self] in
            guard let self else { return }

            if previousView != self.stateView {
                previousView?.removeFromSuperview()
            }

            let isContentHidden = self.stateView != nil
            containerView.isHidden = !isContentHidden
            self.hideableContentView?.isHidden = isContentHidden
        }
        UIAnimator.animate(
            animated: animated,
            kind: .indication,
            animations: animations,
            completion: completion
        )
    }

    private func processing(state: State) {
        delayBag = .init()

        let tag = state.tag

        if state.isDelayed {
            Observable
                .just(Void())
                .delaySubscription(indicationDelay, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [unowned self] in self.display(tag: tag) })
                .disposed(by: delayBag)
        } else {
            display(tag: tag)
        }
    }
}

extension IndicationViewManager: Connectable {
    func connect(_ model: Model) {
        updateData(model)
        bindInputs(model)

        animated = true
    }

    func disconnect() {
        bag = .init()
        delayBag = .init()
        modelBag = nil

        animated = false

        // restore default state
        UIView.performWithoutAnimation {
            self.stateView?.removeFromSuperview()

            if let containerView = self.containerView {
                containerView.isHidden = true
                containerView.alpha = 0
            }

            if let hideableContentView = self.hideableContentView {
                hideableContentView.isHidden = false
                hideableContentView.alpha = 1
            }
        }
    }

    private func bindInputs(_ model: Model) {
        model.state
            .subscribe(onNext: { [unowned self] value in self.processing(state: value) })
            .disposed(by: bag)
    }

    private func updateData(_ model: Model) {
        modelBag = model.bag

        provider = model.provider
        containerView = model.containerView
        hideableContentView = model.hideableContentView

        indicationDelay = model.indicationDelay
    }
}

extension IndicationViewManager {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let state: BehaviorRelay<State>

        // data
        let provider: Provider

        let containerView: UIView
        let hideableContentView: UIView?

        let indicationDelay: RxTimeInterval
    }

    struct State: Equatable {
        let tag: Tag?
        let isDelayed: Bool
    }
}

extension IndicationViewManager.Model where IndicationViewManager.Tag == LoadingState {
    init(
        tag: BehaviorRelay<LoadingState?>,
        provider: Provider,
        containerView: UIView,
        hideableContentView: UIView? = nil
    ) {
        self.init(
            state: .init(),
            provider: provider,
            containerView: containerView,
            hideableContentView: hideableContentView,
            indicationDelay: .delay
        )

        tag
            .map { value in .init(tag: value) }
            .distinctUntilChanged()
            .bind(to: state)
            .disposed(by: bag)
    }
}

extension IndicationViewManager.State: DefaultInitializable {
    init() {
        self.init(
            tag: nil,
            isDelayed: false
        )
    }
}

extension IndicationViewManager.State where IndicationViewManager.Tag == LoadingState {
    init(tag: LoadingState?) {
        let isDelayed = tag?.isLoading() ?? false
        self.init(
            tag: tag,
            isDelayed: isDelayed
        )
    }
}

// MARK: - Constants
private extension RxTimeInterval {
    static let delay = RxTimeInterval.timeInterval(0.15)
}
