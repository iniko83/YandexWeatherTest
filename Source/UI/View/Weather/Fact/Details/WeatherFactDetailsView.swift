//
//  WeatherFactDetailsView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 20.07.2023.
//

import RxRelay
import RxSwift

// TODO: add more details later with collectionView waterfall

@IBDesignable
final class WeatherFactDetailsView: UIView, NibOwnerLoadable {
    private var bag = DisposeBag()

    @IBOutlet private weak var iconView: SvgImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }

    private func update(icon: String) {
        iconView.connect(
            .init(
                name: .network(icon: icon)
            )
        )
    }
}

extension WeatherFactDetailsView: Connectable {
    func connect(_ model: Model) {
        updateData(model)
        bindInputs(model)
    }

    func disconnect() {
        bag = .init()

        updateData(nil)

        iconView.disconnect()
    }

    private func bindInputs(_ model: Model) {
        let baseInfo = model.fact
            .compactMap { $0?.baseInfo }
            .share(replay: 1)

        baseInfo
            .map { $0.temperaturesInfo.currentTemperatureString() }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] value in self.temperatureLabel.text = value })
            .disposed(by: bag)

        baseInfo
            .map { $0.conditionIconAlias }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] value in self.update(icon: value) })
            .disposed(by: bag)
    }

    private func updateData(_ model: Model?) {
        let color = model?.color ?? .clear
        iconView.tintColor = color
        temperatureLabel.textColor = color
    }
}

extension WeatherFactDetailsView {
    struct Model {
        // inputs
        let fact: BehaviorRelay<Weather.Fact?>

        // data
        let color: UIColor
    }
}
