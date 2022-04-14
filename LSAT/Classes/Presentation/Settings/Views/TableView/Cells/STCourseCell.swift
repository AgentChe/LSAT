//
//  STCourseCell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 26.01.2021.
//

import UIKit

final class STCourseCell: UITableViewCell {
    var tapped: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var nameLabel = makeNameLabel()
    lazy var arrowIcon = makeArrowIcon()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension STCourseCell {
    func setup(course: Course) {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.24.scale)
        nameLabel.attributedText = course.name.attributed(with: attrs)
    }
}

// MARK: Private
private extension STCourseCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func didTap() {
        tapped?()
    }
}

// MARK: Make constraints
private extension STCourseCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15.scale),
            nameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -15.scale)
        ])
        
        NSLayoutConstraint.activate([
            arrowIcon.widthAnchor.constraint(equalToConstant: 6.scale),
            arrowIcon.heightAnchor.constraint(equalToConstant: 12.scale),
            arrowIcon.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            arrowIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension STCourseCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mainColor)
            .font(Fonts.SFProRounded.regular(size: 13.scale))
            .lineHeight(20.scale)
            .letterSpacing(-0.24.scale)
        
        let view = UILabel()
        view.attributedText = "Settings.SelectedExam".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeArrowIcon() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Settings.Right")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
