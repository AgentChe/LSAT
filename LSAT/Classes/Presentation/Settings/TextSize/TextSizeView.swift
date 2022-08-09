//
//  TextSizeView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 25.05.2022.
//

import UIKit

final class TextSizeView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var menuView = makeMenuView()
    lazy var titleLabel = makeTitleLabel()
    lazy var questionLabel = makeQuestionLabel()
    lazy var answer1View = makeAnswerView(text: "TextSize.Answer1".localized)
    lazy var answer2View = makeAnswerView(text: "TextSize.Answer2".localized)
    lazy var answer3View = makeAnswerView(text: "TextSize.Answer3".localized)
    lazy var answer4View = makeAnswerView(text: "TextSize.Answer4".localized)
    lazy var dimmedView = makeDimmedView()
    lazy var bottomView = makeBottomView()
    lazy var textSizeLabel = makeTextSizeLabel()
    lazy var minusButton = makeMinusButton()
    lazy var plusButton = makePlusButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TextSizeView {
    func setup(textSize: TextSize) {
        questionLabel.attributedText = "TextSize.Question".localized
            .attributed(with: TextAttributes()
                        .font(Fonts.SFProRounded.semiBold(size: textSize.questionFontSize))
                        .lineHeight(textSize.questionLineHeight)
                        .textColor(Appearance.blackColor))
        
        textSizeLabel.attributedText = String(format: "TextSize.Percent".localized, textSize.percent)
            .attributed(with: TextAttributes()
                        .font(Fonts.SFProRounded.semiBold(size: 17.scale))
                        .lineHeight(20.scale)
                        .letterSpacing(0.37.scale)
                        .textColor(Appearance.blackColor))
        
        answer1View.setup(textSize: textSize)
        answer2View.setup(textSize: textSize)
        answer3View.setup(textSize: textSize)
        answer4View.setup(textSize: textSize)
    }
}

// MARK: Private
private extension TextSizeView {
    func initialize() {
        backgroundColor = Appearance.backgroundColor
    }
}

// MARK: Make constraints
private extension TextSizeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            menuView.widthAnchor.constraint(equalToConstant: 24.scale),
            menuView.heightAnchor.constraint(equalToConstant: 24.scale),
            menuView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            menuView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 56.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            questionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 40.scale : 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            answer1View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            answer1View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            answer1View.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            answer2View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            answer2View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            answer2View.topAnchor.constraint(equalTo: answer1View.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            answer3View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            answer3View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            answer3View.topAnchor.constraint(equalTo: answer2View.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            answer4View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            answer4View.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            answer4View.topAnchor.constraint(equalTo: answer3View.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 168.scale : 140.scale)
        ])
        
        NSLayoutConstraint.activate([
            textSizeLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            textSizeLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale : 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            minusButton.widthAnchor.constraint(equalToConstant: 60.scale),
            minusButton.heightAnchor.constraint(equalToConstant: 60.scale),
            minusButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 120.scale),
            minusButton.topAnchor.constraint(equalTo: textSizeLabel.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 60.scale),
            plusButton.heightAnchor.constraint(equalToConstant: 60.scale),
            plusButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -120.scale),
            plusButton.topAnchor.constraint(equalTo: textSizeLabel.bottomAnchor, constant: 15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TextSizeView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "TextSize.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMenuView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "TextSize.Menu")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "TextSize.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeQuestionLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAnswerView(text: String) -> TextSizeAnswerView {
        let view = TextSizeAnswerView(text: text)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDimmedView() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = Appearance.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextSizeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(view)
        return view
    }
    
    func makeMinusButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "TextSize.Minus"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(view)
        return view
    }
    
    func makePlusButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "TextSize.Plus"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(view)
        return view
    }
}
