//
//  WeatherForecastView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 14.07.2023.
//

import RxRelay
import RxSwift

// TODO: add sunset & moonphase view later

@IBDesignable
final class WeatherForecastMainView: UIView, NibOwnerLoadable {
    private var bag = DisposeBag()
    private var modelBag: DisposeBag?

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var kindSelectionView: WeatherForecastKindSelectionView!

    @IBOutlet private weak var tableContainerView: WeatherForecastTableContainerView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }

    private func update(date: Date) {
        dateLabel.text = date.forecastTitleString()
    }
}

extension WeatherForecastMainView: Connectable {
    func connect(_ model: Model) {
        updateData(model)

        bindInputs(model)

        kindSelectionView.connect(model.kindSelectionViewModel())
        tableContainerView.connect(model.tableContainerViewModel())
    }

    func disconnect() {
        bag = .init()

        updateData(nil)

        kindSelectionView.disconnect()
        tableContainerView.disconnect()
    }

    private func bindInputs(_ model: Model) {
        model.forecast
            .map { $0.date }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] value in self.update(date: value) })
            .disposed(by: bag)
    }

    private func updateData(_ model: Model?) {
        modelBag = model?.bag

        let color = model?.color ?? .clear
        dateLabel.textColor = color
    }
}

extension WeatherForecastMainView {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let forecast: BehaviorRelay<Weather.Forecast>
        let selectedKind: BehaviorRelay<Weather.Forecast.Kind>

        // outputs
        let selectKind: PublishRelay<Weather.Forecast.Kind>

        // data
        let color: UIColor

        fileprivate func kindSelectionViewModel() -> WeatherForecastKindSelectionView.Model {
            .init(
                selectedKind: selectedKind,
                selectKind: selectKind
            )
        }

        fileprivate func tableContainerViewModel() -> WeatherForecastTableContainerView.Model {
            .init(
                forecast: forecast,
                selectedKind: selectedKind,
                color: color
            )
        }
    }
}

extension WeatherForecastMainView.Model {
    init(
        selectedKind: BehaviorRelay<Weather.Forecast.Kind>,
        color: UIColor
    ) {
        self.init(
            forecast: .init(),
            selectedKind: selectedKind,
            selectKind: .init(),
            color: color
        )
    }
}
