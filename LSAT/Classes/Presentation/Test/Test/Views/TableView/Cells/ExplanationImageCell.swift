//
//  ExplanationImageCell.swift
//  CDL
//
//  Created by Vitaliy Zagorodnov on 05.12.2021.
//

import UIKit
import Kingfisher

final class ExplanationImageCell: UITableViewCell {
    lazy var explanationImage = makeImageView()
    
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
extension ExplanationImageCell {
    func confugure(image: URL) {
        explanationImage.kf.setImage(with: image)
    }
}

// MARK: Private
private extension ExplanationImageCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ExplanationImageCell {
    func makeConstraints() {
        let bottomConstraint = explanationImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomConstraint.priority = .init(rawValue: 999)
        NSLayoutConstraint.activate([
            explanationImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            bottomConstraint,
            explanationImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            explanationImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.scale),
            explanationImage.heightAnchor.constraint(equalTo: explanationImage.widthAnchor, multiplier: 0.39)
        ])
    }
}

// MARK: Lazy initialization
private extension ExplanationImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 20.scale
        view.clipsToBounds = true
        contentView.addSubview(view)
        return view
    }
}
