//
//  BottomView.swift
//  FNP
//
//  Created by Vitaliy Zagorodnov on 11.07.2021.
//

import UIKit

class BottomView: UIView {
    lazy var bottomButton = makeBottomButton()
    lazy var nextButton = makeNextButton()
    lazy var gradientView = makeGradientView()
    lazy var preloader = makePreloader()
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bottomButton.frame.contains(point)
    }
}

// MARK: Public
extension BottomView {
    func setup(state: TestBottomButtonState) {
        switch state {
        case .confirm:
            bottomButton.setAttributedTitle("Question.Continue".localized.attributed(with: Self.buttonAttr), for: .normal)
        case .submit:
            bottomButton.setAttributedTitle("Question.Submit".localized.attributed(with: Self.buttonAttr), for: .normal)
        case .back:
            bottomButton.setAttributedTitle("Question.BackToStudying".localized.attributed(with: Self.buttonAttr), for: .normal)
        case .hidden:
            break
        }
        
        bottomButton.isHidden = state == .hidden
    }
}

// MARK: Private
private extension BottomView {
    func initialize() {
        backgroundColor = .clear
    }
    
    static let buttonAttr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 20.scale))
        .lineHeight(23.scale)
        .textColor(.white)
        .textAlignment(.center)
}

// MARK: Make constraints
private extension BottomView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 71.scale : 30.scale),
            bottomButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            bottomButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            bottomButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -36.scale),
            bottomButton.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: bottomButton.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: bottomButton.trailingAnchor),
            nextButton.topAnchor.constraint(equalTo: bottomButton.topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: bottomButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.leadingAnchor.constraint(equalTo: bottomButton.leadingAnchor),
            preloader.trailingAnchor.constraint(equalTo: bottomButton.trailingAnchor),
            preloader.topAnchor.constraint(equalTo: bottomButton.topAnchor),
            preloader.bottomAnchor.constraint(equalTo: bottomButton.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BottomView {
    func makeBottomButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = Appearance.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> UIButton {
        let view = UIButton()
        view.setAttributedTitle("Question.NextQuestion".localized.attributed(with: Self.buttonAttr), for: .normal)
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = Appearance.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGradientView() -> UIView {
        let view = UIView()
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(integralRed: 241, green: 244, blue: 251).cgColor]
        gradientLayer.locations = [0, 0.65]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.mask = gradientLayer
        view.isUserInteractionEnabled = false
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> TestBottomSpinner {
        let view = TestBottomSpinner()
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = Appearance.mainColor
        view.stop()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
