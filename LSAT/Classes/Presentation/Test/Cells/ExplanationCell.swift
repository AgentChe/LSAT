//
//  ExplanationCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import UIKit

class ExplanationCell: UITableViewCell {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var explanationLabel = makeExplanationLabel()

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
extension ExplanationCell {
    func confugure(explanation: String, html: String) {
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.bold(size: 17.scale))
            .textColor(.black)
            .lineHeight(20.scale)
        
        explanationLabel.attributedText = attributedString(for: html) ?? explanation.attributed(with: attr)
    }
}

// MARK: Private
private extension ExplanationCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func attributedString(for htmlString: String) -> NSAttributedString? {
        guard !htmlString.isEmpty else { return nil }
        
        let font = Fonts.SFProRounded.bold(size: 17.scale)
        let htmlWithStyle = "<span style=\"font-family: \(font.fontName); font-style: regular; font-size: \(font.pointSize); line-height: 20px;\">\(htmlString)</span>"
        let data = Data(htmlWithStyle.utf8)
        
        let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        )
        
        return attributedString
    }
}

// MARK: Make constraints
private extension ExplanationCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: explanationLabel.topAnchor, constant: -15.scale)
        ])
        
        NSLayoutConstraint.activate([
            explanationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            explanationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            explanationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExplanationCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.bold(size: 17.scale))
            .textColor(Appearance.mainColor)
            .lineHeight(20.scale)
        
        view.attributedText = "Question.Explanation".localized.attributed(with: attr)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeExplanationLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        contentView.addSubview(view)
        return view
    }
}
