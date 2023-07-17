//
//  ConnectionStatusView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 10.07.2023.
//

import RxRelay
import RxSwift

@IBDesignable
final class ConnectionStatusView: UIView, NibOwnerLoadable {
    private var bag = DisposeBag()

    @IBOutlet private weak var textLabel: UILabel!

    private var isConnected = false
    private var animated = false

    override var intrinsicContentSize: CGSize {
        .noIntrinsic(height: 30)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }

    private func set(isConnected value: Bool) {
        isConnected = value

        updateConnectionStatus()
    }

    private func updateConnectionStatus() {
        UIAnimator.animate(
            animated: animated,
            kind: .color,
            animations: { self.updateConnectionStatusAnimations() }
        )
    }

    private func updateConnectionStatusAnimations() {
        let connectionStatus = ConnectionStatus(isConnected: isConnected)
        backgroundColor = connectionStatus.backgroundColor()

        backgroundColor = isConnected ? .green : .black
        textLabel.text = connectionStatus.text()
    }

    // MARK: - Interface Builder support
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateConnectionStatusAnimations()
    }
}

extension ConnectionStatusView: Connectable {
    struct Model {
        let isConnected: BehaviorRelay<Bool>
    }

    func connect(_ model: Model) {
        bindConnectionStatus(model)

        animated = true
    }

    func disconnect() {
        bag = .init()

        animated = false
    }

    private func bindConnectionStatus(_ model: Model) {
        model.isConnected
            .subscribe(onNext: { [unowned self] value in
                self.set(isConnected: value)
            })
            .disposed(by: bag)
    }
}

private enum ConnectionStatus {
    case offline
    case online

    init(isConnected: Bool) {
        self = isConnected
            ? .online
            : .offline
    }

    private func isOffline() -> Bool {
        self == .offline
    }

    func backgroundColor() -> UIColor {
        // FIXME: - colors
        isOffline()
            ? .black
            : .systemGreen
    }

    func text() -> String {
        isOffline()
            ? L10n.NetworkConnection.Warning.unavailable
            : L10n.NetworkConnection.Warning.connected
    }
}
