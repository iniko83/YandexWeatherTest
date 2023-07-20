//
//  WeatherFactMainView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import RxRelay
import RxSwift

@IBDesignable
final class WeatherFactMainView: UIView, NibOwnerLoadable {
    private var bag = DisposeBag()
    private var modelBag: DisposeBag?

    @IBOutlet private weak var detailsView: WeatherFactDetailsView!
    @IBOutlet private weak var forecastIndexSelectionView: WeatherForecastIndexSelectionView!
    @IBOutlet private weak var locationView: LocationView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
}

extension WeatherFactMainView: Connectable {
    func connect(_ model: Model) {
        updateData(model)

        detailsView.bind(model.detailsViewModel())
        forecastIndexSelectionView.bind(model.forecastIndexSelectionViewModel())
        locationView.bind(model.locationViewModel())
    }

    func disconnect() {
        bag = .init()

        updateData(nil)

        detailsView.disconnect()
        forecastIndexSelectionView.disconnect()
        locationView.disconnect()
    }

    private func updateData(_ model: Model?) {
        modelBag = model?.bag
    }
}

extension WeatherFactMainView {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let fact: BehaviorRelay<Weather.Fact?>
        let forecastDates: BehaviorRelay<[Date]>
        let forecastSelectedIndex: BehaviorRelay<Int>

        let isDefaultCoordinate: BehaviorRelay<Bool>
        let localityName: BehaviorRelay<String?>

        // outputs
        let selectForecastIndex: PublishRelay<Int>

        let tapLocation: PublishRelay<Void>

        // data
        let color: UIColor
        let attentionColor: UIColor

        fileprivate func detailsViewModel() -> WeatherFactDetailsView.Model {
            .init(
                fact: fact,
                color: color
            )
        }

        fileprivate func forecastIndexSelectionViewModel() -> WeatherForecastIndexSelectionView.Model {
            .init(
                dates: forecastDates,
                selectedIndex: forecastSelectedIndex,
                selectIndex: selectForecastIndex
            )
        }

        fileprivate func locationViewModel() -> LocationView.Model {
            .init(
                isAttention: isDefaultCoordinate,
                localityName: localityName,
                tap: tapLocation,
                color: color,
                attentionColor: attentionColor
            )
        }
    }
}

extension WeatherFactMainView.Model {
    init(
        forecastSelectedIndex: BehaviorRelay<Int>,
        localityName: BehaviorRelay<String?>,
        color: UIColor,
        attentionColor: UIColor
    ) {
        fact = .init()
        forecastDates = .init()
        self.forecastSelectedIndex = forecastSelectedIndex
        isDefaultCoordinate = .init()
        self.localityName = localityName
        selectForecastIndex = .init()
        tapLocation = .init()
        self.color = color
        self.attentionColor = attentionColor
    }
}
