//
//  TextItemSelectionView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 20.07.2023.
//

import RxRelay
import RxSwift

protocol TextItemSelectionViewModelDelegate {
    func selectableTextItemCellModel(_ index: Int) -> SelectableTextItemCell.Model
}

extension TextItemSelectionView {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Item>
    typealias Item = Int
    typealias ItemCell = SelectableTextItemCell
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Item>
}

extension TextItemSelectionView.Model {
    typealias Delegate = TextItemSelectionViewModelDelegate
}

final class TextItemSelectionView: UIView {
    private var bag = DisposeBag()
    private var model: Model?

    private var collectionView: UICollectionView!
    private var dataSource: DataSource!

    private let maskLayer = CAGradientLayer.makeHorizontalMaskLayer()

    private var animated = false

    private var collectionContentWidth = 0 {
        didSet {
            updateCollectionContentInset()
        }
    }

    override var intrinsicContentSize: CGSize {
        .noIntrinsic(height: .height)
    }

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
        updateCollectionContentInset()
        updateMaskIfNeeded()
    }

    private func updateCollectionContentInset() {
        let threshold = Int(CGFloat.defaultInset)
        guard collectionContentWidth > threshold else { return }
        let possibleInset = 0.5 * (bounds.width - CGFloat(collectionContentWidth))
        let inset = max(possibleInset, .defaultInset)
        let contentInset = UIEdgeInsets(horizontal: inset)
        collectionView.update(contentInset: contentInset)

        let isScrollEnabled = inset == .defaultInset
        collectionView.isScrollEnabled = isScrollEnabled

        let offset = -inset
        guard collectionView.contentOffset.x > offset else { return }
        let contentOffset = CGPoint(x: offset, y: 0)
        collectionView.setContentOffset(contentOffset, animated: false)
    }

    private func updateMaskIfNeeded() {
        guard maskLayer.frame != bounds else { return }

        maskLayer.updateMaskLocations(
            isVertical: false,
            bounds: bounds,
            insets: .contentInset
        )
        maskLayer.frame = bounds
    }

    // MARK: - Collection Support
    private func makeCollectionLayout() -> UICollectionViewLayout {
        let result = UICollectionViewFlowLayout()
        result.scrollDirection = .horizontal
        result.minimumLineSpacing = .spacing
        result.estimatedItemSize = .init(side: 1)
        return result
    }

    private func makeSnapshot(count: Int) -> Snapshot {
        let items = Array(0 ..< count)
        var result = Snapshot()
        result.appendSections([0])
        result.appendItems(items, toSection: 0)
        return result
    }

    private func setupCollection() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionLayout()
        )
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .contentInset
        collectionView.registerNib(ItemCell.self)
        snapToEdgesAndAddSubview(collectionView)

        dataSource = .init(
            collectionView: collectionView,
            cellProvider: { [unowned self] (containerView, indexPath, item) in
                let model = self.model?.delegate.selectableTextItemCellModel(item)

                guard let model else { return nil }

                let result = containerView.dequeueReusableCell(ItemCell.self, for: indexPath)
                result.bind(model)
                return result
            }
        )
    }

    private func updateCollection(count: Int) {
        let snapshot = makeSnapshot(count: count)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension TextItemSelectionView: Connectable {
    func connect(_ model: Model) {
        updateData(model)

        bindCollectionUpdates(model)
        bindCollectionWidthObserving()
        bindItemSelection(model)

        animated = true
    }

    func disconnect() {
        bag = .init()

        updateData(nil)

        animated = false
    }

    private func bindCollectionUpdates(_ model: Model) {
        model.count
            .subscribe(onNext: { [unowned self] value in
                self.updateCollection(count: value)
            })
            .disposed(by: bag)
    }

    private func bindCollectionWidthObserving() {
        collectionView.rx
            .observe(CGSize.self, #keyPath(UIScrollView.contentSize))
            .asObservable()
            .compactMap { value in
                guard let value else { return nil }
                return Int(value.width)
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] value in self.collectionContentWidth = value })
            .disposed(by: bag)
    }

    private func bindItemSelection(_ model: Model) {
        collectionView.rx.itemSelected
            .map { [unowned self] indexPath in self.dataSource.item(at: indexPath) }
            .bind(to: model.selectIndex)
            .disposed(by: bag)
    }

    private func updateData(_ model: Model?) {
        self.model = model
    }
}

extension TextItemSelectionView {
    struct Model {
        let bag = DisposeBag()

        // inputs
        let count: BehaviorRelay<Int>
        let selectedIndex: BehaviorRelay<Int>

        // outputs
        let selectIndex: PublishRelay<Int>

        // data
        let delegate: Delegate
    }
}

extension TextItemSelectionView.Model {
    init(
        selectedIndex: BehaviorRelay<Int>,
        selectIndex: PublishRelay<Int>,
        delegate: Delegate
    ) {
        self.init(
            count: .init(),
            selectedIndex: selectedIndex,
            selectIndex: selectIndex,
            delegate: delegate
        )
    }

    init(
        count: Int,
        delegate: Delegate
    ) {
        self.init(
            count: .init(value: count),
            selectedIndex: .init(),
            selectIndex: .init(),
            delegate: delegate
        )
    }
}

// MARK: - Constants
private extension CGFloat {
    static let defaultInset: CGFloat = 16
    static let height: CGFloat = 32
    static let spacing: CGFloat = 12
}

private extension UIEdgeInsets {
    static let contentInset = Self(horizontal: .defaultInset)
}
