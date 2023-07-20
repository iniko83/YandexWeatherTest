//
//  WeatherForecastIndexSelectionView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import RxRelay
import RxSwift

final class WeatherForecastIndexSelectionView: UIView {
    private var modelBag: DisposeBag?

    private var selectionView = TextItemSelectionView()

    override var intrinsicContentSize: CGSize {
        selectionView.intrinsicContentSize
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        snapToEdgesAndAddSubview(selectionView)
    }
}

extension WeatherForecastIndexSelectionView: Connectable {
    func connect(_ model: Model) {
        updateData(model)

        selectionView.connect(model.selectionViewModel())
    }

    func disconnect() {
        updateData(nil)

        selectionView.disconnect()
    }

    private func updateData(_ model: Model?) {
        modelBag = model?.bag
    }
}

extension WeatherForecastIndexSelectionView {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let dates: BehaviorRelay<[Date]>
        let selectedIndex: BehaviorRelay<Int>

        // outputs
        let selectIndex: PublishRelay<Int>

        fileprivate func selectionViewModel() -> TextItemSelectionView.Model {
            let result = TextItemSelectionView.Model(
                selectedIndex: selectedIndex,
                selectIndex: selectIndex,
                delegate: self
            )
            let bag = result.bag

            dates
                .map { $0.count }
                .distinctUntilChanged()
                .bind(to: result.count)
                .disposed(by: bag)

            return result
        }
    }
}

extension WeatherForecastIndexSelectionView.Model: TextItemSelectionViewModelDelegate {
    func selectableTextItemCellModel(_ index: Int) -> SelectableTextItemCell.Model {
        let result = SelectableTextItemCell.Model()
        let bag = result.bag

        dates
            .compactMap { $0[safe: index] }
            .distinctUntilChanged()
            .map { date in date.forecastShortTitleString() }
            .bind(to: result.text)
            .disposed(by: bag)

        selectedIndex
            .map { value in index == value }
            .distinctUntilChanged()
            .bind(to: result.isItemSelected)
            .disposed(by: bag)

        return result
    }
}
