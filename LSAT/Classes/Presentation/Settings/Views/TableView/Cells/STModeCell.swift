//
//  STModeCell.swift
//  FNP
//
//  Created by Andrey Chernyshev on 12.07.2021.
//

import UIKit

final class STModeCell: UITableViewCell {
    var tapped: ((TestMode) -> Void)?
    
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var nameLabel = makeNameLabel()
    lazy var arrowIcon = makeArrowIcon()
    
    private var testMode: TestMode?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension STModeCell {
    func setup(mode: TestMode) {
        self.testMode = mode
        
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 224, green: 117, blue: 140))
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.24.scale)
            .textAlignment(.right)
        
        switch mode {
        case .fullComplect:
            nameLabel.attributedText = "Onboarding.Modes.Cell1.Title".localized.attributed(with: attrs)
        case .noExplanations:
            nameLabel.attributedText = "Onboarding.Modes.Cell2.Title".localized.attributed(with: attrs)
        case .onAnExam:
            nameLabel.attributedText = "Onboarding.Modes.Cell3.Title".localized.attributed(with: attrs)
        }
    }
}

// MARK: Private
private extension STModeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didTap() {
        guard let mode = testMode else {
            return
        }
        
        tapped?(mode)
    }
}

// MARK: Make constraints
private extension STModeCell {
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
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 80.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -40.scale),
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
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
private extension STModeCell {
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
        view.attributedText = "Settings.ExamMode".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
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
