//
//  WeatherBaseInfoTableCell.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import RxRelay
import RxSwift

extension WeatherBaseInfoTableCell {
    typealias Info = Weather.BaseInfo
}

final class WeatherBaseInfoTableCell: UITableViewCell, NibReusable {
    private var bag = DisposeBag()
    private var modelBag: DisposeBag?

    @IBOutlet private weak var identifierTextLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var conditionIconView: SvgImageView!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windInfoView: WeatherWindInfoView!

    private var animated = false

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    // MARK: -
    private func updateInfo(_ value: Info) {
        temperatureLabel.text = value.temperaturesInfo.temperatureString()
        feelsLikeLabel.text = value.temperaturesInfo.feelsLikeString()
        pressureLabel.text = value.pressureString()
        humidityLabel.text = value.humidityString()

        updateConditionIcon(value.conditionIconAlias)
    }

    private func updateConditionIcon(_ value: String) {
        let model = SvgImageView.Model(name: .network(icon: value))
        conditionIconView.bind(model)
    }
}

extension WeatherBaseInfoTableCell: Connectable {
    func connect(_ model: Model) {
        updateData(model)

        bindInputs(model)

        windInfoView.connect(model.windInfoViewModel())

        animated = true
    }

    func disconnect() {
        bag = .init()

        updateData(nil)

        windInfoView.disconnect()

        animated = false
    }

    private func bindInputs(_ model: Model) {
        model.info
            .subscribe(onNext: { [unowned self] value in self.updateInfo(value) })
            .disposed(by: bag)
    }

    private func updateData(_ model: Model?) {
        modelBag = model?.bag

        identifierTextLabel.text = model?.identifierText

        let color = model?.color ?? .clear
        identifierTextLabel.textColor = color
        temperatureLabel.textColor = color
        feelsLikeLabel.textColor = color
        pressureLabel.textColor = color
        humidityLabel.textColor = color
    }
}

extension WeatherBaseInfoTableCell {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let info: BehaviorRelay<Info>

        // data
        let identifierText: String
        let color: UIColor

        fileprivate func windInfoViewModel() -> WeatherWindInfoView.Model {
            let result = WeatherWindInfoView.Model(color: color)
            let bag = result.bag

            info
                .map { info in info.wind }
                .distinctUntilChanged()
                .bind(to: result.wind)
                .disposed(by: bag)

            return result
        }
    }
}

extension WeatherBaseInfoTableCell.Model {
    init(
        identifierText: String,
        color: UIColor
    ) {
        info = .init()
        self.identifierText = identifierText
        self.color = color
    }
}
