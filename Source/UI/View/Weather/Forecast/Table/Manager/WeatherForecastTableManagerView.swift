//
//  WeatherForecastTableManagerView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 20.07.2023.
//

import RxRelay
import RxSwift

extension WeatherForecastTableManagerView {
    typealias DataSource = UITableViewDiffableDataSource<Int, Item>
    typealias Forecast = Weather.Forecast
    typealias Item = Forecast.Identificator
    typealias ItemCell = WeatherBaseInfoTableCell
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Item>
}

final class WeatherForecastTableManagerView: UIView {
    private var bag = DisposeBag()
    private var model: Model?

    private let tableView = UITableView.make()
    private var dataSource: DataSource!

    private let maskLayer = CAGradientLayer.makeVerticalMaskLayer()

    private var animated = false

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        layer.mask = maskLayer

        setupCollection()
    }

    // MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()

        updateMaskIfNeeded()
    }

    private func updateMaskIfNeeded() {
        guard maskLayer.frame != bounds else { return }

        maskLayer.updateMaskLocations(
            isVertical: true,
            bounds: bounds,
            insets: .contentInset
        )
        maskLayer.frame = bounds
    }

    // MARK: - Collection Support
    private func makeSnapshot(items: [Item]) -> Snapshot {
        var result = Snapshot()
        result.appendSections([0])
        result.appendItems(items, toSection: 0)
        return result
    }

    private func setupCollection() {
        tableView.contentInset = .contentInset
        tableView.registerNib(ItemCell.self)
        snapToEdgesAndAddSubview(tableView)

        dataSource = .init(
            tableView: tableView,
            cellProvider: { [unowned self] (containerView, indexPath, item) in
                guard let model = self.model?.itemCellModel(item) else { return nil }

                let result = containerView.dequeueReusableCell(ItemCell.self, for: indexPath)
                result.bind(model)
                return result
            }
        )
        dataSource.defaultRowAnimation = .fade
    }

    private func updateCollection(items: [Item]) {
        tableView.configureDefaultStyle()

        let snapshot = makeSnapshot(items: items)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension WeatherForecastTableManagerView: Connectable {
    func connect(_ model: Model) {
        updateData(model)

        bindCollectionUpdates(model)

        animated = true
    }

    func disconnect() {
        bag = .init()

        updateData(nil)

        animated = false
    }

    private func bindCollectionUpdates(_ model: Model) {
        model.items
            .subscribe(onNext: { [unowned self] value in
                self.updateCollection(items: value)
            })
            .disposed(by: bag)
    }

    private func updateData(_ model: Model?) {
        self.model = model
    }
}

extension WeatherForecastTableManagerView {
    struct Model {
        // inputs
        let forecast: BehaviorRelay<Forecast>
        let items: BehaviorRelay<[Item]>

        // data
        let color: UIColor

        func itemCellModel(_ item: Item) -> ItemCell.Model {
            let result = ItemCell.Model(
                identifierText: item.title(),
                color: color
            )
            let bag = result.bag

            forecast
                .compactMap { $0.baseInfo(id: item) }
                .distinctUntilChanged()
                .bind(to: result.info)
                .disposed(by: bag)

            return result
        }
    }
}

// MARK: - Constants
private extension UIEdgeInsets {
    static let contentInset = Self(vertical: 16)
}
