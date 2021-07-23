//
//  CourseCollectionCell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit

final class CourseCollectionCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var titleLabel = makeLabel()
    lazy var subTitleLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension CourseCollectionCell {
    func setup(element: CoursesCollectionElement) {
        titleLabel.attributedText = element.course.name
            .attributed(with: TextAttributes()
                            .textColor(UIColor.black)
                            .font(Fonts.SFProRounded.bold(size: 25.scale))
                            .lineHeight(29.scale)
                            .textAlignment(.center))

        subTitleLabel.attributedText = element.course.subTitle
            .attributed(with: TextAttributes()
                            .textColor(UIColor.black.withAlphaComponent(0.33))
                            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
                            .lineHeight(20.scale)
                            .textAlignment(.center))

        container.layer.borderWidth = element.isSelected ? 4.scale : 0
        container.layer.borderColor = element.isSelected ? Appearance.mainColor.cgColor : UIColor.clear.cgColor
    }
}

// MARK: Private
private extension CourseCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension CourseCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -104.scale)
        ])

        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 70.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CourseCollectionCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
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
}
