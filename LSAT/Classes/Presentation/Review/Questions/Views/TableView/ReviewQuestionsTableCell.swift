//
//  ReviewQuestionsTableCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 19.06.2022.
//

import UIKit

final class ReviewQuestionsTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ReviewQuestionsTableCell {
    func setup(element: Review) {
        iconView.image = UIImage(named: element.isCorrectly ? "Review.Success" : "Review.Failure")
        
        let question = element.question.questionShort ?? element.question.question
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(23.8.scale)
        label.attributedText = question.attributed(with: attrs)
        
        container.layer.borderColor = element.isCorrectly ? Appearance.successColor.cgColor : Appearance.errorColor.cgColor
        
        iconView.image = UIImage(named: element.isCorrectly ? "ReviewQuestions.Correct" : "ReviewQuestions.Incorrect")
    }
}

// MARK: Make constraints
private extension ReviewQuestionsTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ReviewQuestionsTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -54.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 19.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -19.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20.scale),
            iconView.heightAnchor.constraint(equalToConstant: 15.scale),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -19.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReviewQuestionsTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.layer.borderWidth = 3.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
