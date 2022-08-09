//
//  QuestionReferenceCell.swift
//  FNP
//
//  Created by Andrey Chernyshev on 14.07.2021.
//

import UIKit

class QuestionReferenceCell: UITableViewCell {
    private lazy var referenceLabel = makeReferenceLabel()

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
extension QuestionReferenceCell {
    func confugure(reference: String) {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 12.scale))
            .textColor(UIColor.black.withAlphaComponent(0.54))
            .lineHeight(14.scale)
            .textAlignment(.center)
        
        referenceLabel.attributedText = reference.attributed(with: attrs)
    }
}

// MARK: Private
private extension QuestionReferenceCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension QuestionReferenceCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            referenceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            referenceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            referenceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            referenceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionReferenceCell {
    func makeReferenceLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        contentView.addSubview(view)
        return view
    }
}
