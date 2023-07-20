//
//  LocationView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 20.07.2023.
//

import RxRelay
import RxSwift

final class LocationView: UIView, NibOwnerLoadable {
    private var bag = DisposeBag()
    private var modelBag: DisposeBag?

    @IBOutlet private weak var button: SvgImageButton!
    @IBOutlet private weak var localityLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
}

extension LocationView: Connectable {
    func connect(_ model: Model) {
        updateData(model)

        bindInputs(model)

        button.connect(model.buttonModel())
    }

    func disconnect() {
        bag = .init()

        updateData(nil)

        button.disconnect()
    }

    private func bindInputs(_ model: Model) {
        let color = model.color
        let attentionColor = model.attentionColor

        model.isAttention
            .map { $0 ? color : attentionColor }
            .subscribe(onNext: { [unowned self] value in self.localityLabel.textColor = value } )
            .disposed(by: bag)

        model.localityName
            .subscribe(onNext: { [unowned self] value in self.localityLabel.text = value } )
            .disposed(by: bag)
    }

    private func updateData(_ model: Model?) {
        modelBag = model?.bag
    }
}

extension LocationView {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let isAttention: BehaviorRelay<Bool>
        let localityName: BehaviorRelay<String?>

        // outputs
        let tap: PublishRelay<Void>

        // data
        let color: UIColor
        let attentionColor: UIColor

        fileprivate func buttonModel() -> SvgImageButton.Model {
            let result = SvgImageButton.Model(
                tap: tap,
                name: .local(.location)
            )

            isAttention
                .map { $0 ? .attention : .default }
                .bind(to: result.style)
                .disposed(by: bag)

            return result
        }
    }
}
