//
//  QuestionsProgressCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 11.02.2021.
//

import UIKit

class QuestionsProgressCell: UITableViewCell {
    private lazy var titleLabel = makeLabel()

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
extension QuestionsProgressCell {
    func configure(title: String) {
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(20.scale)
            .textColor(UIColor.black.withAlphaComponent(0.5))
            .textAlignment(.center)
        
        titleLabel.attributedText = title.attributed(with: attr)
    }
}

// MARK: Private
private extension QuestionsProgressCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension QuestionsProgressCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.scale),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.scale),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionsProgressCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
