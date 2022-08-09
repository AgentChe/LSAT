//
//  ExplanationTitleCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 05.12.2021.
//

import UIKit

final class ExplanationTitleCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ExplanationTitleCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ExplanationTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExplanationTitleCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.bold(size: 17.scale))
            .textColor(Appearance.mainColor)
            .lineHeight(22.scale)
        
        view.attributedText = "Question.Explanation".localized.attributed(with: attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

