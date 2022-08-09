//
//  SettingsPremiumCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import UIKit

final class SettingsPremiumCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var container = makeContainer()
    lazy var memberSinceView = makeMemberSinceView()
    lazy var validTillView = makeValidTillView()
    lazy var userIdView = makeUserIdView()
    
    private lazy var validTillViewBottomConstraint = NSLayoutConstraint()
    
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
extension SettingsPremiumCell {
    func setup(element: SettingsPremium) {
        titleLabel.attributedText = element.title
            .attributed(with: TextAttributes()
                        .textColor(Appearance.blackColor)
                        .font(Fonts.SFProRounded.semiBold(size: 17.scale))
                        .lineHeight(20.scale))
        
        memberSinceView.valueLabel.attributedText = element.memberSince
            .attributed(with: TextAttributes()
                            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
                        .font(Fonts.SFProRounded.regular(size: 17.scale))
                        .lineHeight(20.scale))
        
        validTillView.valueLabel.attributedText = element.validTill
            .attributed(with: TextAttributes()
                            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
                        .font(Fonts.SFProRounded.regular(size: 17.scale))
                        .lineHeight(20.scale))
        
        if let userId = element.userId {
            userIdView.valueLabel.attributedText = String(userId)
                .attributed(with: TextAttributes()
                                .textColor(Appearance.blackColor.withAlphaComponent(0.5))
                            .font(Fonts.SFProRounded.regular(size: 17.scale))
                            .lineHeight(20.scale))
        }
        
        let hasUserId = element.userId != nil
        
        validTillView.separator.isHidden = !hasUserId
        userIdView.isHidden = !hasUserId
        
        validTillView.layer.cornerRadius = hasUserId ? 0 : 16.scale
        validTillView.layer.maskedCorners = hasUserId ? [] : [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        validTillViewBottomConstraint.isActive = false
        if hasUserId {
            validTillViewBottomConstraint = validTillView.bottomAnchor.constraint(equalTo: userIdView.topAnchor)
        } else {
            validTillViewBottomConstraint = validTillView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        }
        validTillViewBottomConstraint.isActive = true
    }
}

// MARK: Private
private extension SettingsPremiumCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SettingsPremiumCell {
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
            memberSinceView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            memberSinceView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            memberSinceView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        validTillViewBottomConstraint = validTillView.bottomAnchor.constraint(equalTo: userIdView.topAnchor)
        NSLayoutConstraint.activate([
            validTillView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            validTillView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            validTillView.topAnchor.constraint(equalTo: memberSinceView.bottomAnchor),
            
        ])
        
        NSLayoutConstraint.activate([
            userIdView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            userIdView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            userIdView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsPremiumCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
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
    
    func makeMemberSinceView() -> SettingsPremiumView {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = SettingsPremiumView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.placeholderLabel.attributedText = "Settings.Premium.MemberSince".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeValidTillView() -> SettingsPremiumView {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = SettingsPremiumView()
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = true
        view.placeholderLabel.attributedText = "Settings.Premium.ValidTill".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeUserIdView() -> SettingsPremiumView {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = SettingsPremiumView()
        view.separator.isHidden = true
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.placeholderLabel.attributedText = "Settings.Premium.UserId".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
