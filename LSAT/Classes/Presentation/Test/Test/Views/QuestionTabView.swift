//
//  QuestionTabView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 26.05.2022.
//

import UIKit

final class QuestionTabView: UIView {
    lazy var previousButton = makePreviousButton()
    lazy var nextButton = makeNextButton()
    lazy var favoriteButton = makeFavoriteButton()
    lazy var reportButton = makeReportButton()
    
    private let testType: TestType
    
    init(testType: TestType) {
        self.testType = testType
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension QuestionTabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            previousButton.widthAnchor.constraint(equalToConstant: 40.scale),
            previousButton.heightAnchor.constraint(equalToConstant: 40.scale),
            previousButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            previousButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 22.scale : 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 40.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 40.scale),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nextButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 22.scale : 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 24.scale),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24.scale),
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 20.scale)
        ])
        
        if testType.isQotd() {
            favoriteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 123.scale).isActive = true
        } else {
            favoriteButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            reportButton.widthAnchor.constraint(equalToConstant: 24.scale),
            reportButton.heightAnchor.constraint(equalToConstant: 24.scale),
            reportButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 20.scale),
            reportButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 227.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionTabView {
    func makePreviousButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.isHidden = testType.isQotd()
        view.setImage(UIImage(named: "Question.Tab.Previous"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.isHidden = testType.isQotd()
        view.setImage(UIImage(named: "Question.Tab.Next"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFavoriteButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeReportButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.isHidden = !testType.isQotd()
        view.setImage(UIImage(named: "Question.Tab.Report"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
