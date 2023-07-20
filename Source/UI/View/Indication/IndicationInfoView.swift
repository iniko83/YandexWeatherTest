//
//  IndicationInfoView.swift
//  YandexWeatherTest
//
//  Created by Igor Nikolaev on 18.07.2023.
//

import UIKit

final class IndicationInfoView: UIView {
    private let iconView = SvgImageView()
    private let textLabel = UILabel()

    private let stackView = UIStackView()

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
        let color = Asset.Assets.text.color
        textLabel.textColor = color
        iconView.tintColor = color

        textLabel.font = .systemFont(ofSize: .fontSize)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0

        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = .stackSpacing

        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(textLabel)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        let iconAspectRationConstraint = iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor, multiplier: 1)
        let iconWidthConstraint = iconView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5)

        let topStackViewConstraint = stackView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: .padding)
        topStackViewConstraint.priority = .defaultHigh - 1

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .padding),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.padding),
            topStackViewConstraint,
            iconAspectRationConstraint,
            iconWidthConstraint
        ])
    }
}

extension IndicationInfoView: Connectable {
    func connect(_ model: Model) {
        let iconViewModel = model.iconViewModel()
        if let model = iconViewModel {
            iconView.connect(model)
        }
        iconView.isHidden = iconViewModel == nil

        textLabel.text = model.text
        textLabel.isHidden = model.text == nil
    }

    func disconnect() {
        iconView.disconnect()
        textLabel.text = nil
    }
}

extension IndicationInfoView {
    struct Model {
        let icon: SvgImageName.Local?
        let text: String?

        fileprivate func iconViewModel() -> SvgImageView.Model? {
            guard let icon else { return nil }
            return .init(
                name: .local(icon),
                isTemplate: true
            )
        }
    }
}

// MARK: - Constants
private extension CGFloat {
    static let fontSize: CGFloat = 17
    static let padding: CGFloat = 24
    static let stackSpacing: CGFloat = 16
}
