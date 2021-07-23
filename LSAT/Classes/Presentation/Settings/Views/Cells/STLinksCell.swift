//
//  STLinksCell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 26.01.2021.
//

import UIKit

final class STLinksCell: UITableViewCell {
    var tapped: ((SettingsTableView.Tapped) -> Void)?
    
    lazy var rateUsView = makeRateUsView()
    lazy var contactUsView = makeContactUsView()
    lazy var termsOfUse = makeTermsOfUseView()
    lazy var privacyPolicyView = makePrivacyPolicyView()
    
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
private extension STLinksCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }
    
    @objc
    func didTap(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else {
            return
        }
        
        switch tag {
        case 1:
            tapped?(.rateUs)
        case 2:
            tapped?(.contactUs)
        case 3:
            tapped?(.termsOfUse)
        case 4:
            tapped?(.privacyPoliicy)
        default:
            break
        }
    }
}

// MARK: Make constraints
private extension STLinksCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            rateUsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            rateUsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            rateUsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rateUsView.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            contactUsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            contactUsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            contactUsView.topAnchor.constraint(equalTo: rateUsView.bottomAnchor),
            contactUsView.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfUse.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            termsOfUse.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            termsOfUse.topAnchor.constraint(equalTo: contactUsView.bottomAnchor),
            termsOfUse.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            privacyPolicyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            privacyPolicyView.topAnchor.constraint(equalTo: termsOfUse.bottomAnchor),
            privacyPolicyView.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension STLinksCell {
    func makeRateUsView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.tag = 1
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.label.text = "Settings.RateUs".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeContactUsView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.tag = 2
        view.backgroundColor = UIColor.white
        view.label.text = "Settings.ContactUs".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTermsOfUseView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.tag = 3
        view.backgroundColor = UIColor.white
        view.label.text = "Settings.TermsOfUse".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePrivacyPolicyView() -> STLinkView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = STLinkView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.tag = 4
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.label.text = "Settings.PrivacyPolicy".localized
        view.placeholder.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
