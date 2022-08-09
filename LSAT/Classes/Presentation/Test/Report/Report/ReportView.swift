//
//  ReportView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import UIKit

final class ReportView: UIView {
    lazy var scrollView = makeScrollView()
    lazy var backButton = makeBackButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var messageTitleLabel = makeBlockTitleLabel(text: "Report.Message.Title".localized)
    lazy var messageView = makeMessageView()
    lazy var feedbackLabel = makeBlockTitleLabel(text: "Report.Feedback.Title".localized)
    lazy var feedbackSwitch = makeFeedbackSwitch()
    lazy var emailTitleLabel = makeBlockTitleLabel(text: "Report.Email".localized)
    lazy var emailField = makeEmailField()
    lazy var reportButton = makeReportButton()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        feedbackChanged()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ReportView {
    func initialize() {
        backgroundColor = Appearance.backgroundColor
    }
    
    @objc
    func feedbackChanged() {
        emailTitleLabel.isHidden = !feedbackSwitch.isOn
        emailField.isHidden = !feedbackSwitch.isOn
        emailField.reset()
    }
}

// MARK: Make constraints
private extension ReportView {
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
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            scrollView.bottomAnchor.constraint(equalTo: reportButton.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            messageTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24.scale),
            messageTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24.scale),
            messageTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale : 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            messageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24.scale),
            messageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24.scale),
            messageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 217.scale : 170.scale),
            messageView.topAnchor.constraint(equalTo: messageTitleLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            feedbackLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24.scale),
            feedbackLabel.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 39.scale)
        ])
        
        NSLayoutConstraint.activate([
            feedbackSwitch.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -33.scale),
            feedbackSwitch.centerYAnchor.constraint(equalTo: feedbackLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24.scale),
            emailTitleLabel.bottomAnchor.constraint(equalTo: emailField.topAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            emailField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            emailField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            emailField.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 121.scale),
            emailField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 60.scale),
            emailField.widthAnchor.constraint(equalToConstant: 343.scale)
        ])
        
        NSLayoutConstraint.activate([
            reportButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            reportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            reportButton.heightAnchor.constraint(equalToConstant: 60.scale),
            reportButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: reportButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: reportButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ReportView {
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Report.Back"), for: .normal)
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
        view.attributedText = "Report.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Report.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.contentInsetAdjustmentBehavior = .never
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBlockTitleLabel(text: String) -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = text.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeMessageView() -> ReportMessageView {
        let view = ReportMessageView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeFeedbackSwitch() -> UISwitch {
        let view = UISwitch()
        view.onTintColor = Appearance.mainColor
        view.tintColor = Appearance.mainColor.withAlphaComponent(0.7)
        view.thumbTintColor = UIColor.white
        view.addTarget(self, action: #selector(feedbackChanged), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeEmailField() -> ReportEmailField {
        let view = ReportEmailField()
        view.backgroundColor = UIColor.white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeReportButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.mainColor
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Report.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 32.scale, height: 32.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
