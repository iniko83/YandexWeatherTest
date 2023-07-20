//
//  WarningTextButton.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import RxCocoa
import RxSwift

@IBDesignable
final class WarningTextButton: UIControl, NibOwnerLoadable {
    private var bag = DisposeBag()
    private var modelBag: DisposeBag?

    @IBOutlet private weak var titleLabel: UILabel!

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

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        loadNibContent()
        titleLabel.superview?.isUserInteractionEnabled = false
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
        backgroundColor = style.backgroundColor(state)
        titleLabel.textColor = style.titleColor(state)
    }

    private func updateColorsIfAnimated() {
        guard animated else { return }
        updateColors()
    }

    // MARK: - Interface Builder support
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateColorsAnimation()
    }
}

extension WarningTextButton: Connectable {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let isEnabled: BehaviorRelay<Bool>
        let text: BehaviorRelay<String>

        let style: BehaviorRelay<Style>

        // outputs
        let tap: PublishRelay<Void>

        init(
            isEnabled: BehaviorRelay<Bool> = .enabled(),
            text: BehaviorRelay<String> = .init(),
            style: BehaviorRelay<Style> = .init(),
            tap: PublishRelay<Void> = .init()
        ) {
            self.isEnabled = isEnabled
            self.text = text
            self.style = style
            self.tap = tap
        }
    }

    func connect(_ model: Model) {
        updateData(model)

        bindInputs(model)
        bindOutputs(model)

        updateColors()

        animated = true
    }

    func disconnect() {
        bag = .init()

        updateData(nil)

        animated = false
    }

    private func bindInputs(_ model: Model) {
        model.isEnabled
            .subscribe(onNext: { [unowned self] value in
                self.isEnabled = value
            })
            .disposed(by: bag)

        model.text
            .subscribe(onNext: { [unowned self] value in
                self.titleLabel?.text = value
            })
            .disposed(by: bag)

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

    private func updateData(_ model: Model?) {
        modelBag = model?.bag
    }
}

extension WarningTextButton {
    enum Style: Int, DefaultInitializable {
        case `default`

        init() {
            self = .default
        }

        fileprivate func backgroundColor(_ state: UIControl.State) -> UIColor {
            let result: UIColor
            switch state {
            case .highlighted:
                result = Asset.Assets.warningOrange.color.withAddBrightness(0.15)
            case .disabled:
                result = UIColor.systemGray
            default:
                result = Asset.Assets.warningOrange.color
            }
            return result
        }

        fileprivate func titleColor(_ state: UIControl.State) -> UIColor {
            let color = Asset.Assets.warningText.color

            let result: UIColor
            switch state {
            case .highlighted:
                result = color.withAlphaComponent(0.75)
            case .disabled:
                result = color.withAlphaComponent(0.5)
            default:
                result = color
            }
            return result
        }
    }
}
