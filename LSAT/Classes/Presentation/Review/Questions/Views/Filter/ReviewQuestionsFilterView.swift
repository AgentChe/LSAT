//
//  ReviewQuestionsFilterView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 19.06.2022.
//

import UIKit

enum ReviewQuestionsFilter {
    case all, correct, incorrect
}

final class ReviewQuestionsFilterView: UIView {
    var filter: ReviewQuestionsFilter = .all {
        didSet {
            update()
        }
    }
    
    lazy var allButton = makeButton(title: "ReviewQuestions.Filter.All".localized)
    lazy var correctButton = makeButton(title: "ReviewQuestions.Filter.Correct".localized)
    lazy var incorrectButton = makeButton(title: "ReviewQuestions.Filter.Incorrect".localized)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ReviewQuestionsFilterView {
    func update() {
        let buttons = [
            allButton,
            correctButton,
            incorrectButton
        ]
        
        buttons.forEach {
            $0.isChecked = false
        }
        
        switch filter {
        case .all: allButton.isChecked = true
        case .correct: correctButton.isChecked = true
        case .incorrect: incorrectButton.isChecked = true
        }
    }
}

// MARK: Make constraints
private extension ReviewQuestionsFilterView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            allButton.widthAnchor.constraint(equalToConstant: 21.scale),
            allButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            allButton.topAnchor.constraint(equalTo: topAnchor),
            allButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            correctButton.widthAnchor.constraint(equalToConstant: 57.scale),
            correctButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65.scale),
            correctButton.topAnchor.constraint(equalTo: topAnchor),
            correctButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            incorrectButton.widthAnchor.constraint(equalToConstant: 68.scale),
            incorrectButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 142.scale),
            incorrectButton.topAnchor.constraint(equalTo: topAnchor),
            incorrectButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ReviewQuestionsFilterView {
    func makeButton(title: String) -> ReviewQuestionsFilterButton {
        let view = ReviewQuestionsFilterButton(title: title)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
