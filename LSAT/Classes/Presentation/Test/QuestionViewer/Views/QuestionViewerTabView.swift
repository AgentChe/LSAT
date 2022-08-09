//
//  QuestionViewerTabView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 20.06.2022.
//

import UIKit

final class QuestionViewerTabView: UIView {
    lazy var previousButton = makePreviousButton()
    lazy var nextButton = makeNextButton()
    lazy var favoriteButton = makeFavoriteButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension QuestionViewerTabView {
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
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 20.scale),
            favoriteButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionViewerTabView {
    func makePreviousButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Question.Tab.Previous"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> TapAreaButton {
        let view = TapAreaButton()
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
}
