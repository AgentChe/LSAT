//
//  ReviewFilterView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 17.06.2022.
//

import UIKit

final class ReviewFilterView: UIButton {
    enum Filter {
        case quizes, questions
    }
    
    var selectedTab = Filter.quizes {
        didSet {
            update()
        }
    }
    
    lazy var quizesButton = makeButton(text: "Review.Filter.Quizes".localized)
    lazy var questionsButton = makeButton(text: "Review.Filter.Questions".localized)
    
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
private extension ReviewFilterView {
    func update() {
        quizesButton.mode = selectedTab == .quizes ? .selected : .deselected
        questionsButton.mode = selectedTab == .questions ? .selected : .deselected
    }
}

// MARK: Make constraints
private extension ReviewFilterView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            quizesButton.widthAnchor.constraint(equalToConstant: 167.scale),
            quizesButton.heightAnchor.constraint(equalToConstant: 32.scale),
            quizesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.scale),
            quizesButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            questionsButton.widthAnchor.constraint(equalToConstant: 167.scale),
            questionsButton.heightAnchor.constraint(equalToConstant: 32.scale),
            questionsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.scale),
            questionsButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ReviewFilterView {
    func makeButton(text: String) -> ReviewFilterButton {
        let view = ReviewFilterButton(text: text)
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
