//
//  SettingsSupportCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import UIKit

final class SettingsSupportCell: UITableViewCell {
    weak var tableDelegate: SettingsTableDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var container = makeContainer()
    lazy var contactUsButton = makeContactUsButton()
    lazy var termsOfUserButton = makeTermsOfUseButton()
    lazy var privacyPolicyButton = makePrivacyPolicyButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SettingsSupportCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func contactUsTapped() {
        tableDelegate?.settingsTableDidTappedContactUs()
    }
    
    @objc
    func termsOfUserTapped() {
        tableDelegate?.settingsTableDidTappedTermsOfUse()
    }
    
    @objc
    func privacyPolicyTapped() {
        tableDelegate?.settingsTableDidTappedPrivacyPolicy()
    }
}

// MARK: Make constraints
private extension SettingsSupportCell {
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
            contactUsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            contactUsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            contactUsButton.topAnchor.constraint(equalTo: container.topAnchor),
            contactUsButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfUserButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            termsOfUserButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            termsOfUserButton.topAnchor.constraint(equalTo: contactUsButton.bottomAnchor),
            termsOfUserButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            privacyPolicyButton.topAnchor.constraint(equalTo: termsOfUserButton.bottomAnchor),
            privacyPolicyButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsSupportCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "Settings.Support".localized.attributed(with: attrs)
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
    
    func makeContactUsButton() -> SettingsArrowButton {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = SettingsArrowButton()
        view.placeholderLabel.attributedText = "Settings.Support.ContactUs".localized.attributed(with: attrs)
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(contactUsTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeTermsOfUseButton() -> SettingsArrowButton {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = SettingsArrowButton()
        view.placeholderLabel.attributedText = "Settings.Support.TermsOfUse".localized.attributed(with: attrs)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(termsOfUserTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makePrivacyPolicyButton() -> SettingsArrowButton {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = SettingsArrowButton()
        view.placeholderLabel.attributedText = "Settings.Support.PrivacyPolicy".localized.attributed(with: attrs)
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.separator.isHidden = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(privacyPolicyTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
