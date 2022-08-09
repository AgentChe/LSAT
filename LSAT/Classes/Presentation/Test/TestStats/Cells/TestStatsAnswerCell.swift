//
//  TestStatsAnswerCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import UIKit

class TestStatsAnswerCell: UITableViewCell {
    
    private lazy var containerView = makeContainerView()
    private lazy var iconView = makeIconView()
    private lazy var answerLabel = makeAnswerLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: Public
extension TestStatsAnswerCell {
    func setup(element: Review) {
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(20)
            .textColor(.black)
        
        let question = element.question.questionShort ?? element.question.question
        
        answerLabel.attributedText = question.attributed(with: attr)
        iconView.image = element.isCorrectly
            ? UIImage(named: "Question.Correct")
            : UIImage(named: "Question.Error")
        
        let color = element.isCorrectly
            ? Appearance.successColor
            : Appearance.errorColor
        
        iconView.tintColor = color
        
        containerView.backgroundColor = color.withAlphaComponent(0.15)
        containerView.layer.borderColor = color.cgColor
    }
}

// MARK: Private
private extension TestStatsAnswerCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TestStatsAnswerCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.scale),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.scale),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            answerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.scale),
            answerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 19.scale),
            answerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -19.scale),
            answerLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -20.scale),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsAnswerCell {
    func makeContainerView() -> UIView {
        let view = UIView()
        view.layer.borderWidth = 3.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20.scale
        contentView.addSubview(view)
        return view
    }
    
    func makeAnswerLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
}
