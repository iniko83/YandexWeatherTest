//
//  SvgImageButton.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 14.07.2023.
//

import RxCocoa
import RxSwift

final class SvgImageButton: UIControl {
    private var bag = DisposeBag()
    private var modelBag: DisposeBag?

    private let imageView = SvgImageView()

    private var animated = false

    private var style = Style() {
        didSet {
            updateColorsIfAnimated()
        }
    }

    // MARK: - Overrided variables
    override var isEnabled: Bool {
        didSet {
            updateColorsIfAnimated()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateColorsIfAnimated()
        }
    }

    override var isSelected: Bool {
        didSet {
            updateColorsIfAnimated()
        }
    }

    // MARK: - Animations support
    private func isColorsAnimated() -> Bool {
        isHighlighted && isEnabled
            ? false
            : animated
    }

    private func updateColors() {
        UIAnimator.animate(
            animated: isColorsAnimated(),
            kind: .color,
            animations: { self.updateColorsAnimation() }
        )
    }

    private func updateColorsAnimation() {
        imageView.tintColor = style.tintColor(state)
    }

    private func updateColorsIfAnimated() {
        guard animated else { return }
        updateColors()
    }
}

extension SvgImageButton: Connectable {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let style: BehaviorRelay<Style>

        // outputs
        let tap: PublishRelay<Void>

        // data
        let name: SvgImageName
    }

    func connect(_ model: Model) {
        modelBag = model.bag

        bindInputs(model)
        bindOutputs(model)

        imageView.bind(model.imageViewModel())
    }

    func disconnect() {
        bag = .init()
        modelBag = nil
    }

    private func bindInputs(_ model: Model) {
        model.style
            .subscribe(onNext: { [unowned self] value in
                self.style = value
            })
            .disposed(by: bag)
    }

    private func bindOutputs(_ model: Model) {
        rx
            .controlEvent(.touchUpInside)
            .bind(to: model.tap)
            .disposed(by: bag)
    }
}

extension SvgImageButton.Model {
    init(
        tap: PublishRelay<Void> = .init(),
        name: SvgImageName
    ) {
        style = .init()
        self.tap = tap
        self.name = name
    }

    fileprivate func imageViewModel() -> SvgImageView.Model {
        .init(
            name: name,
            isTemplate: true
        )
    }
}

extension SvgImageButton {
    enum Style: Int, DefaultInitializable {
        case `default`
        case attention

        init() {
            self = .default
        }

        private func isDefault() -> Bool {
            self == .default
        }

        fileprivate func tintColor(_ state: UIControl.State) -> UIColor {
            // FIXME: - colors
            let result: UIColor
            switch state {
            case .highlighted:
                result = isDefault()
                    ? UIColor.systemOrange.withAlphaComponent(0.75)
                    : UIColor.systemRed.withAlphaComponent(0.75)
            case .disabled:
                result = UIColor.systemGray.withAlphaComponent(0.15)
            default:
                result = isDefault()
                    ? UIColor.systemGray
                    : UIColor.systemRed
            }
            return result
        }
    }
}