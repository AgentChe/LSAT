//
//  ReportOptionsView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import UIKit

final class ReportOptionsView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var reportButton = makeOptionButton(icon: "ReportOptions.Report", text: "ReportOptions.Report".localized)
    lazy var restartButton = makeOptionButton(icon: "ReportOptions.Restart", text: "ReportOptions.Restart".localized)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ReportOptionsView {
    func initialize() {
        backgroundColor = Appearance.backgroundColor
    }
}

// MARK: Make constraints
private extension ReportOptionsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9.scale),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            reportButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            reportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            reportButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.scale),
            reportButton.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            restartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            restartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            restartButton.topAnchor.constraint(equalTo: reportButton.bottomAnchor, constant: 12.scale),
            restartButton.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReportOptionsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(22.scale)
            .letterSpacing(-0.41.scale)
        
        let view = UILabel()
        view.attributedText = "ReportOptions.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "TestOptions.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeOptionButton(icon: String, text: String) -> ReportOptionButton {
        let view = ReportOptionButton(icon: icon, text: text)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
