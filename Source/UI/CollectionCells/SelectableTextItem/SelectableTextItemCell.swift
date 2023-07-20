//
//  SelectableTextItemCell.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import RxRelay
import RxSwift

@IBDesignable
final class SelectableTextItemCell: UICollectionViewCell, NibReusable {
    private var bag = DisposeBag()
    private var modelBag: DisposeBag?

    @IBOutlet private weak var textLabel: UILabel!

    private var animated = false

    private var isItemSelected = false {
        didSet {
            updateColorsIfAnimated()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateColorsIfAnimated()
        }
    }

    // MARK: - Animations support
    private func isColorsAnimated() -> Bool {
        isHighlighted
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
        let alpha: CGFloat = isHighlighted ? 0.75 : 1

        let backgroundColor: UIColor
        let textColor: UIColor
        if isItemSelected || isHighlighted {
            backgroundColor = Asset.Assets.text.color.withAlphaComponent(alpha)
            textColor = Asset.Assets.background.color
        } else {
            backgroundColor = .clear
            textColor = Asset.Assets.text.color
        }

        contentView.backgroundColor = backgroundColor
        textLabel.textColor = textColor.withAlphaComponent(alpha)
    }

    private func updateColorsIfAnimated() {
        guard animated else { return }
        updateColors()
    }
}

extension SelectableTextItemCell: Connectable {
    func connect(_ model: Model) {
        updateData(model)

        bindInputs(model)

        updateColors()

        animated = true
    }

    func disconnect() {
        bag = .init()

        updateData(nil)

        animated = false
    }

    private func bindInputs(_ model: Model) {
        model.isItemSelected
            .subscribe(onNext: { [unowned self] value in self.isItemSelected = value })
            .disposed(by: bag)

        model.text
            .subscribe(onNext: { [unowned self] value in self.textLabel.text = value })
            .disposed(by: bag)
    }

    private func updateData(_ model: Model?) {
        modelBag = model?.bag
    }
}

extension SelectableTextItemCell {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let isItemSelected: BehaviorRelay<Bool>
        let text: BehaviorRelay<String>
    }
}

extension SelectableTextItemCell.Model: DefaultInitializable {
    init() {
        self.init(
            isItemSelected: .init(),
            text: .init()
        )
    }

    init(text: String) {
        self.init(
            isItemSelected: .init(),
            text: .init(value: text)
        )
    }
}

