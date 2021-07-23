//
//  ReferencesTableCell.swift
//  FNP
//
//  Created by Andrey Chernyshev on 10.07.2021.
//

import UIKit

final class ReferencesTableCell: UITableViewCell {
    lazy var circleView = makeCircleView()
    lazy var titleLabel = makeLabel()
    lazy var detailsLabel = makeLabel()
    
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
extension ReferencesTableCell {
    func setup(reference: Reference) {
        titleLabel.attributedText = reference
            .title
            .attributed(with: TextAttributes()
                            .textColor(UIColor.black.withAlphaComponent(0.9))
                            .font(Fonts.SFProRounded.bold(size: 19.scale))
                            .lineHeight(22.scale))
        
        detailsLabel.attributedText = reference
            .details
            .attributed(with: TextAttributes()
                            .textColor(UIColor(integralRed: 75, green: 81, blue: 102))
                            .font(Fonts.SFProRounded.regular(size: 17.scale))
                            .lineHeight(20.scale))
    }
}

// MARK: Private
private extension ReferencesTableCell {
    func initialize() {
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ReferencesTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: 7.scale),
            circleView.heightAnchor.constraint(equalToConstant: 7.scale),
            circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            circleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30.scale),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ReferencesTableCell {
    func makeCircleView() -> CircleView {
        let view = CircleView()
        view.backgroundColor = Appearance.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
