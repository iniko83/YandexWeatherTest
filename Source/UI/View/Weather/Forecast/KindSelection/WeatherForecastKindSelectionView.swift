//
//  WeatherForecastKindSelectionView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 19.07.2023.
//

import RxRelay
import RxSwift

extension WeatherForecastKindSelectionView.Model {
    typealias Kind = Weather.Forecast.Kind
}

final class WeatherForecastKindSelectionView: UIView {
    private var selectionView = TextItemSelectionView()

    override var intrinsicContentSize: CGSize {
        selectionView.intrinsicContentSize
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        snapToEdgesAndAddSubview(selectionView)
    }
}

extension WeatherForecastKindSelectionView: Connectable {
    func connect(_ model: Model) {
        selectionView.connect(model.selectionViewModel())
    }

    func disconnect() {
        selectionView.disconnect()
    }
}

extension WeatherForecastKindSelectionView {
    struct Model {
        // inputs
        let selectedKind: BehaviorRelay<Kind>

        // outputs
        let selectKind: PublishRelay<Kind>

        fileprivate func selectionViewModel() -> TextItemSelectionView.Model {
            let result = TextItemSelectionView.Model(
                count: Kind.allCases.count,
                delegate: self
            )
            let bag = result.bag

            selectedKind
                .map { $0.rawValue }
                .bind(to: result.selectedIndex)
                .disposed(by: bag)

            result.selectIndex
                .map { value in Kind(index: value) }
                .bind(to: selectKind)
                .disposed(by: bag)

            return result
        }
    }
}

extension WeatherForecastKindSelectionView.Model: TextItemSelectionViewModelDelegate {
    func selectableTextItemCellModel(_ index: Int) -> SelectableTextItemCell.Model {
        let kind = Kind(index: index)
        let text = kind.title()

        let result = SelectableTextItemCell.Model(text: text)
        let bag = result.bag

        selectedKind
            .map { value in kind == value }
            .distinctUntilChanged()
            .bind(to: result.isItemSelected)
            .disposed(by: bag)

        return result
    }
}
