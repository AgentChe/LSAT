//
//  SCBriefCell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 31.01.2021.
//

import UIKit

final class SCBriefCell: UICollectionViewCell {
    lazy var courseNameLabel = makeCourseNameLabel()
    lazy var streakLabel = makeStreakLabel()
    lazy var briefDaysView = makeBriefDaysView()
    
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
extension SCBriefCell {
    func setup(element: SCEBrief) {
        courseNameLabel.text = element.courseName
        
        let streakDays = String.choosePluralForm(byNumber: element.streakDays,
                                                 one: "Study.Day.One".localized,
                                                 two: "Study.Day.Two".localized,
                                                 many: "Study.Day.Many".localized)
        streakLabel.text = String(format: "%i %@ %@", element.streakDays, streakDays, "Study.Streak".localized)
        
        briefDaysView.setup(calendar: element.calendar)
    }
}

// MARK: Private
private extension SCBriefCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension SCBriefCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            courseNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            courseNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            streakLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            streakLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            briefDaysView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            briefDaysView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            briefDaysView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale),
            briefDaysView.heightAnchor.constraint(equalToConstant: 58.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SCBriefCell {
    func makeCourseNameLabel() -> UILabel {
        let view = UILabel()
        view.font = Fonts.SFProRounded.bold(size: 13.scale)
        view.textColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeStreakLabel() -> UILabel {
        let view = UILabel()
        view.font = Fonts.SFProRounded.regular(size: 13.scale)
        view.textColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeBriefDaysView() -> SCBriefDaysView {
        let view = SCBriefDaysView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
