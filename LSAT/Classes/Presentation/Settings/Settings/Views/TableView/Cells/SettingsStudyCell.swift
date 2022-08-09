//
//  SettingsStudyCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import UIKit

final class SettingsStudyCell: UITableViewCell {
    weak var tableDelegate: SettingsTableDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var container = makeContainer()
    lazy var testModeButton = makeTestModeButton()
    lazy var vibrationButton = makeVibrationButton()
    lazy var textSizeButton = makeTextSizeButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsStudyCell {
    func setup(element: SettingsStudy) {
        let testMode = formattedTestMode(element.testMode)
        testModeButton.valueLabel.attributedText = testMode
            .attributed(with: TextAttributes()
                        .textColor(Appearance.mainColor)
                        .font(Fonts.SFProRounded.semiBold(size: 17.scale))
                        .lineHeight(20.scale))
        
        vibrationButton.switchView.isOn = element.vibration
    }
}

// MARK: Private
private extension SettingsStudyCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func formattedTestMode(_ testMode: TestMode?) -> String {
        guard let testMode = testMode else {
            return ""
        }

        switch testMode {
        case .noExplanations:
            return "Settings.Study.ExamMode.WithoutExplanations".localized
        case .fullComplect:
            return "Settings.Study.ExamMode.FullSupport".localized
        case .onAnExam:
            return "Settings.Study.ExamMode.ExamStyle".localized
        }
    }
    
    @objc
    func examModeTapped() {
        tableDelegate?.settingsTableDidTappedTestMode()
    }
    
    @objc
    func vibrationTapped() {
        vibrationButton.switchView.isOn.toggle()
        
        tableDelegate?.settingsTableDidChanged(vibration: vibrationButton.switchView.isOn)
    }
    
    @objc
    func textSizeTapped() {
        tableDelegate?.settingsTableDidTappedTextSize()
    }
}

// MARK: Make constraints
private extension SettingsStudyCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            testModeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            testModeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            testModeButton.topAnchor.constraint(equalTo: container.topAnchor),
            testModeButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            vibrationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            vibrationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            vibrationButton.topAnchor.constraint(equalTo: testModeButton.bottomAnchor),
            vibrationButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            textSizeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textSizeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textSizeButton.topAnchor.constraint(equalTo: vibrationButton.bottomAnchor),
            textSizeButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsStudyCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "Settings.Study".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTestModeButton() -> SettingsArrowButton {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = SettingsArrowButton()
        view.placeholderLabel.attributedText = "Settings.Study.ExamMode".localized.attributed(with: attrs)
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(examModeTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeVibrationButton() -> SettingsVibrationButton {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = SettingsVibrationButton()
        view.placeholderLabel.attributedText = "Settings.Study.Vibration".localized.attributed(with: attrs)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(vibrationTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeTextSizeButton() -> SettingsArrowButton {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = SettingsArrowButton()
        view.placeholderLabel.attributedText = "Settings.Study.TextSize".localized.attributed(with: attrs)
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.separator.isHidden = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(textSizeTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
