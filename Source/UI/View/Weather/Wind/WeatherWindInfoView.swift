//
//  WeatherWindInfoView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import RxRelay
import RxSwift

@IBDesignable
final class WeatherWindInfoView: UIView, NibOwnerLoadable {
    private var bag = DisposeBag()
    private var modelBag: DisposeBag?

    @IBOutlet private weak var directionIconView: SvgImageView!
    @IBOutlet private weak var directionLabel: UILabel!
    @IBOutlet private weak var speedLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!

    private var animated = false

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
        setupDirectionIconView()
    }

    private func setupDirectionIconView() {
        directionIconView.alpha = 0.6

        directionIconView.bind(
            .init(
                name: .local(.windDirection),
                isTemplate: true
            )
        )
    }

    private func updateWind(_ wind: Wind) {
        directionLabel.text = wind.direction.shortText().localizedUppercase
        speedLabel.text = wind.speed.description

        UIAnimator.animate(
            animated: animated,
            kind: .updateCollection,
            animations: { self.updateWindAnimations(wind.direction) }
        )
    }

    private func updateWindAnimations(_ direction: Wind.Direction) {
        let rotation = direction.rotation()
        directionIconView.transform = .identity.rotated(by: rotation)

        let isHidden = direction.isCalm()
        directionIconView.isHidden = isHidden
        speedLabel.isHidden = isHidden

        stackView.layoutIfNeeded()
    }
}

extension WeatherWindInfoView: Connectable {
    func connect(_ model: Model) {
        updateData(model)

        bindInputs(model)

        animated = true
    }

    func disconnect() {
        bag = .init()

        updateData(nil)

        animated = false
    }

    private func bindInputs(_ model: Model) {
        model.wind
            .subscribe(onNext: { [unowned self] value in self.updateWind(value) })
            .disposed(by: bag)
    }

    private func updateData(_ model: Model?) {
        modelBag = model?.bag

        let color = model?.color ?? .clear

        directionIconView.tintColor = color
        directionLabel.textColor = color
        speedLabel.textColor = color

        stackView.spacing = model?.spacing ?? .spacing
    }
}

extension WeatherWindInfoView {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let wind: BehaviorRelay<Wind>

        // data
        let color: UIColor
        let spacing: CGFloat
    }
}

extension WeatherWindInfoView.Model {
    init(
        color: UIColor,
        spacing: CGFloat = .spacing
    ) {
        self.init(
            wind: .init(),
            color: color,
            spacing: spacing
        )
    }
}

// MARK: - Constants
private extension CGFloat {
    static let spacing: CGFloat = 8
}
