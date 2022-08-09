//
//  OModeCell.swift
//  FNP
//
//  Created by Andrey Chernyshev on 10.07.2021.
//

import UIKit

final class OModeCell: UIView {
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
                .textColor(Appearance.blackColor)
                .font(Fonts.SFProRounded.semiBold(size: 20.scale))
                .lineHeight(28.scale)
            titleLabel.attributedText = title.attributed(with: attrs)
        }
    }
    
    var subtitle: String = "" {
        didSet {
            let attrs = TextAttributes()
                .textColor(Appearance.greyColor)
                .font(Fonts.SFProRounded.regular(size: 15.scale))
                .lineHeight(21.scale)
            subtitleLabel.attributedText = subtitle.attributed(with: attrs)
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
private extension OModeCell {
    func initialize() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 20.scale
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }
}

// MARK: Make constraints
private extension OModeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 56.scale),
            imageView.heightAnchor.constraint(equalToConstant: 48.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 86.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 86.scale),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.scale),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OModeCell {
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
