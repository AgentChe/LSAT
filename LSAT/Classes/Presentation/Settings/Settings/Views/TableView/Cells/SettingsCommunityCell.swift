//
//  SettingsCommunityCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import UIKit

final class SettingsCommunityCell: UITableViewCell {
    weak var tableDelegate: SettingsTableDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var container = makeContainer()
    lazy var rateUsButton = makeRateUsButton()
    lazy var joinTheCommunityButton = makeJoinTheCommunityButton()
    lazy var shareWithFriendButton = makeShareWithFriendButton()
    
    private lazy var shareWithFriendButtonTopConstraint = NSLayoutConstraint()
    
    private var element: SettingsCommunity?
    
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
extension SettingsCommunityCell {
    func setup(element: SettingsCommunity) {
        self.element = element
        
        update()
    }
}

// MARK: Private
private extension SettingsCommunityCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func update() {
        guard let element = element else {
            return
        }
        
        joinTheCommunityButton.isHidden = element.communityUrl == nil
        
        shareWithFriendButtonTopConstraint.isActive = false
        
        if element.communityUrl == nil {
            shareWithFriendButtonTopConstraint = shareWithFriendButton.topAnchor.constraint(equalTo: rateUsButton.bottomAnchor)
        } else {
            shareWithFriendButtonTopConstraint = shareWithFriendButton.topAnchor.constraint(equalTo: joinTheCommunityButton.bottomAnchor)
        }
        
        shareWithFriendButtonTopConstraint.isActive = true
    }
    
    @objc
    func rateUsTapped() {
        tableDelegate?.settingsTableDidTappedRateUs()
    }
    
    @objc
    func joinTheCommunityTapped() {
        guard let url = element?.communityUrl else {
            return
        }
        
        tableDelegate?.settingsTableDidTappedJoinTheCommunity(url: url)
    }
    
    @objc
    func shareWithFriedTapped() {
        tableDelegate?.settingsTableDidTappedShareWithFriend()
    }
}

// MARK: Make constraints
private extension SettingsCommunityCell {
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
            rateUsButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            rateUsButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            rateUsButton.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            joinTheCommunityButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            joinTheCommunityButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            joinTheCommunityButton.topAnchor.constraint(equalTo: rateUsButton.bottomAnchor)
        ])
        
        shareWithFriendButtonTopConstraint = shareWithFriendButton.topAnchor.constraint(equalTo: joinTheCommunityButton.bottomAnchor)
        NSLayoutConstraint.activate([
            shareWithFriendButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            shareWithFriendButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            shareWithFriendButtonTopConstraint,
            shareWithFriendButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsCommunityCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "Settings.Community".localized.attributed(with: attrs)
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
    
    func makeRateUsButton() -> SettingsCommunityButton {
        let titleAttrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.24.scale)
        
        let subTitleAttrs = TextAttributes()
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
            .font(Fonts.SFProRounded.regular(size: 15.scale))
            .lineHeight(20.scale)
        
        let view = SettingsCommunityButton()
        view.iconView.image = UIImage(named: "Settings.RateUs")
        view.headerLabel.attributedText = "Settings.Community.RateUs.Title".localized.attributed(with: titleAttrs)
        view.subTitleLabel.attributedText = "Settings.Community.RateUs.SubTitle".localized.attributed(with: subTitleAttrs)
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(rateUsTapped), for: .touchUpInside)
        container.addSubview(view)
        return view
    }
    
    func makeJoinTheCommunityButton() -> SettingsCommunityButton {
        let titleAttrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.24.scale)
        
        let subTitleAttrs = TextAttributes()
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
            .font(Fonts.SFProRounded.regular(size: 15.scale))
            .lineHeight(20.scale)
        
        let view = SettingsCommunityButton()
        view.headerLabel.attributedText = "Settings.Community.JoinTheCommunity.Title".localized.attributed(with: titleAttrs)
        view.subTitleLabel.attributedText = "Settings.Community.JoinTheCommunity.SubTitle".localized.attributed(with: subTitleAttrs)
        view.iconView.image = UIImage(named: "Settings.JoinTheCommunity")
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(joinTheCommunityTapped), for: .touchUpInside)
        container.addSubview(view)
        return view
    }
    
    func makeShareWithFriendButton() -> SettingsCommunityButton {
        let titleAttrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.24.scale)
        
        let subTitleAttrs = TextAttributes()
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
            .font(Fonts.SFProRounded.regular(size: 15.scale))
            .lineHeight(20.scale)
        
        let view = SettingsCommunityButton()
        view.headerLabel.attributedText = "Settings.Community.ShareWithFriend.Title".localized.attributed(with: titleAttrs)
        view.subTitleLabel.attributedText = "Settings.Community.ShareWithFriend.SubTitle".localized.attributed(with: subTitleAttrs)
        view.iconView.image = UIImage(named: "Settings.ShareWithFriend")
        view.separator.isHidden = true
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(shareWithFriedTapped), for: .touchUpInside)
        container.addSubview(view)
        return view
    }
}
