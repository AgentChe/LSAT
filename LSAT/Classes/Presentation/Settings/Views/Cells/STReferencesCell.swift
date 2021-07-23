//
//  STReferencesCell.swift
//  FNP
//
//  Created by Andrey Chernyshev on 19.07.2021.
//

import UIKit

final class STReferencesCell: UITableViewCell {
    var tapped: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var arrowIcon = makeArrowIcon()
    
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
private extension STReferencesCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didTap() {
        tapped?()
    }
}

// MARK: Make constraints
private extension STReferencesCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15.scale),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowIcon.widthAnchor.constraint(equalToConstant: 6.scale),
            arrowIcon.heightAnchor.constraint(equalToConstant: 12.scale),
            arrowIcon.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            arrowIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension STReferencesCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.24.scale)
        
        let view = UILabel()
        view.attributedText = "Settings.References".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeArrowIcon() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Settings.Right")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
