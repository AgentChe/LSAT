//
//  BottomView.swift
//  FNP
//
//  Created by Vitaliy Zagorodnov on 11.07.2021.
//

import UIKit

final class BottomView: UIView {
    enum State {
        case confirm
        case submit
        case back
        case next
        case hidden
    }
    
    lazy var button = makeButton()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if button.isHidden {
            return false
        }
        
        return bounds.contains(point)
    }
}

// MARK: Public
extension BottomView {
    func setup(state: BottomView.State) {
        button.setAttributedTitle(state.buttonTitle.attributed(with: .buttonAttr), for: .normal)
        button.isHidden = state == .hidden
    }
}

// MARK: Private
private extension BottomView {
    func initialize() {
        backgroundColor = .clear
    }
}

// MARK: Make constraints
private extension BottomView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            preloader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            preloader.topAnchor.constraint(equalTo: topAnchor),
            preloader.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BottomView {
    func makeButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = Appearance.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> UIButton {
        let view = UIButton()
        view.setAttributedTitle("Question.NextQuestion".localized.attributed(with: .buttonAttr), for: .normal)
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = Appearance.mainColor
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

private extension BottomView.State {
    var buttonTitle: String {
        switch self {
        case .confirm:
            return "Question.Continue".localized
        case .submit:
            return "Question.Submit".localized
        case .back:
            return "Question.BackToStudying".localized
        case .next:
            return "Question.NextQuestion".localized
        case .hidden:
            return ""
        }
    }
}

private extension TextAttributes {
    static let buttonAttr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 20.scale))
        .lineHeight(23.scale)
        .textColor(.white)
        .textAlignment(.center)
}
