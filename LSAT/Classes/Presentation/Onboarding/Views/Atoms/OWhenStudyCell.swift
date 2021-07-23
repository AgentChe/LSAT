//
//  OWhenStudyCell.swift
//  FNP
//
//  Created by Andrey Chernyshev on 10.07.2021.
//

import UIKit

final class OWhenStudyCell: UIView {
    var isSelected = false {
        didSet {
            layer.borderWidth = isSelected ? 4.scale : 0
            layer.borderColor = isSelected ? Appearance.mainColor.cgColor : UIColor.clear.cgColor
        }
    }
    
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeLabel()
    lazy var subtitleLabel = makeLabel()
    
    var title: String = "" {
        didSet {
            let attrs = TextAttributes()
                .textColor(UIColor.black)
                .font(Fonts.SFProRounded.regular(size: 20.scale))
                .lineHeight(24.scale)
            titleLabel.attributedText = title.attributed(with: attrs)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OWhenStudyCell {
    func initialize() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 20.scale
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }
}

// MARK: Make constraints
private extension OWhenStudyCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -116.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20.scale),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100.scale),
            imageView.heightAnchor.constraint(equalToConstant: 68.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OWhenStudyCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
