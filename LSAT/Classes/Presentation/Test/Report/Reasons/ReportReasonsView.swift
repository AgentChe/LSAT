//
//  ReportReasonsView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import UIKit

final class ReportReasonsView: UIView {
    lazy var backButton = makeBackButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var reason1Button = makeReasonButton(reason: .answerIsWrong)
    lazy var reason2Button = makeReasonButton(reason: .caughtTypo)
    lazy var reason3Button = makeReasonButton(reason: .confusing)
    lazy var reason4Button = makeReasonButton(reason: .notWorking)
    
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
private extension ReportReasonsView {
    func initialize() {
        backgroundColor = Appearance.backgroundColor
    }
}

// MARK: Make constraints
private extension ReportReasonsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24.scale),
            backButton.heightAnchor.constraint(equalToConstant: 24.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9.scale),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
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
            reason1Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            reason1Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            reason1Button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.scale),
            reason1Button.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            reason2Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            reason2Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            reason2Button.topAnchor.constraint(equalTo: reason1Button.bottomAnchor, constant: 12.scale),
            reason2Button.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            reason3Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            reason3Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            reason3Button.topAnchor.constraint(equalTo: reason2Button.bottomAnchor, constant: 12.scale),
            reason3Button.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            reason4Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            reason4Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            reason4Button.topAnchor.constraint(equalTo: reason3Button.bottomAnchor, constant: 12.scale),
            reason4Button.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReportReasonsView {
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "ReportReason.Back"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(22.scale)
            .letterSpacing(-0.41.scale)
        
        let view = UILabel()
        view.attributedText = "ReportReason.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "ReportReason.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeReasonButton(reason: ReportReason) -> ReportReasonButton {
        let view = ReportReasonButton(reason: reason)
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
