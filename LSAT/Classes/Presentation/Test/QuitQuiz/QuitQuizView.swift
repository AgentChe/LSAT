//
//  QuitQuizView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 30.05.2022.
//

import UIKit

final class QuitQuizView: UIView {
    lazy var dimmedView = makeDimmedView()
    lazy var container = makeContainer()
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var quitButton = makeQuitButton()
    lazy var submitButton = makeSubmitButton()
    lazy var continueButton = makeContinueButton()
    
    lazy var containerBottomConstraint = NSLayoutConstraint()
    
    private let allQuestionsCount: Int
    private let answeredQuestionsCount: Int
    
    init(allQuestionsCount: Int, answeredQuestionsCount: Int) {
        self.allQuestionsCount = allQuestionsCount
        self.answeredQuestionsCount = answeredQuestionsCount
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension QuitQuizView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        containerBottomConstraint = container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 370.scale : 330.scale)
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerBottomConstraint,
            container.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 370.scale : 330.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            quitButton.widthAnchor.constraint(equalToConstant: 323.scale),
            quitButton.heightAnchor.constraint(equalToConstant: 60.scale),
            quitButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            quitButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            submitButton.widthAnchor.constraint(equalToConstant: 323.scale),
            submitButton.heightAnchor.constraint(equalToConstant: 60.scale),
            submitButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: quitButton.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.widthAnchor.constraint(equalToConstant: 323.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 60.scale),
            continueButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            continueButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension QuitQuizView {
    func makeDimmedView() -> UIView {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.backgroundColor
        view.layer.cornerRadius = 20.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Question.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.bold(size: 20.scale))
            .lineHeight(24.scale)
            .textColor(Appearance.blackColor)
            .letterSpacing(0.37.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Question.QuitQuiz.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(23.8.scale)
            .textColor(Appearance.blackColor)
            .textAlignment(.center)
        
        let string = String(format: "Question.QuitQuiz.SubTitle".localized, answeredQuestionsCount, allQuestionsCount)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = string.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeQuitButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textColor(UIColor.white)
        
        let view = UIButton()
        view.setAttributedTitle("Question.QuitQuiz.QuitQuiz".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = Appearance.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSubmitButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textColor(Appearance.mainColor)
        
        let view = UIButton()
        view.setAttributedTitle("Question.QuitQuiz.SubmitQuiz".localized.attributed(with: attrs), for: .normal)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textColor(Appearance.mainColor)
        
        let view = UIButton()
        view.setAttributedTitle("Question.QuitQuiz.ContinueQuiz".localized.attributed(with: attrs), for: .normal)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
