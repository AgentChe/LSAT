//
//  QuizesTableQuizCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 18.06.2022.
//

import UIKit

final class QuizesTableQuizCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var iconView = makeIconView()
    lazy var titleLabel = makeLabel()
    lazy var arrowView = makeArrowView()
    lazy var scoreLabel = makeLabel()
    lazy var timeLabel = makeLabel()
    lazy var averageTimeLabel = makeLabel()
    
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
extension QuizesTableQuizCell {
    func setup(element: QuizesTableQuiz) {
        setup(type: element.type)
        setup(scoreValue: element.score)
        setup(time: element.time, averageTime: element.averageTime)
    }
}

// MARK: Private
private extension QuizesTableQuizCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func setup(type: TestType) {
        iconView.image = icon(type: type)
        
        titleLabel.attributedText = title(type: type)
            .attributed(with: TextAttributes()
                            .textColor(Appearance.blackColor)
                            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
                            .lineHeight(20.scale))
    }
    
    func icon(type: TestType) -> UIImage? {
        switch type {
        case .get:
            return UIImage(named: "Review.Mode.Random")
        case .tenSet:
            return UIImage(named: "Review.Mode.Ten")
        case .failedSet:
            return UIImage(named: "Review.Mode.Missed")
        case .qotd:
            return UIImage(named: "Review.Mode.Todays")
        case .randomSet:
            return UIImage(named: "Review.Mode.Random")
        case .saved:
            return UIImage(named: "Review.Mode.Saved")
        case .timed:
            return UIImage(named: "Review.Mode.Timed")
        }
    }
    
    func title(type: TestType) -> String {
        switch type {
        case .get:
            return "Quizes.Mode.Get".localized
        case .tenSet:
            return "Quizes.Mode.TenQuestions".localized
        case .failedSet:
            return "Quizes.Mode.MissedQuestions".localized
        case .qotd:
            return "Quizes.Mode.TodaysQuestion".localized
        case .randomSet:
            return "Quizes.Mode.RandomSet".localized
        case .saved:
            return "Quizes.Mode.Saved".localized
        case .timed:
            return "Quizes.Mode.Timed".localized
        }
    }
    
    func setup(scoreValue: Int) {
        let score = String(scoreValue)
            .attributed(with: TextAttributes()
                            .textColor(Appearance.blackColor)
                            .font(Fonts.SFProRounded.bold(size: 34.scale))
                            .lineHeight(40.scale))
        let percent = " %"
            .attributed(with: TextAttributes()
                            .textColor(Appearance.blackColor)
                            .font(Fonts.SFProRounded.bold(size: 17.scale))
                            .lineHeight(20.scale))
        
        let string = NSMutableAttributedString()
        string.append(score)
        string.append(percent)
        
        scoreLabel.attributedText = string
    }
    
    func setup(time: Int, averageTime: Int) {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
            .font(Fonts.SFProRounded.regular(size: 15.scale))
            .lineHeight(18.scale)
        
        timeLabel.attributedText = String(format: "Quizes.YourTime".localized, secondsToString(time))
            .attributed(with: attrs)
        averageTimeLabel.attributedText = String(format: "Quizes.AverageTime".localized, secondsToString(averageTime))
            .attributed(with: attrs)
    }
    
    func secondsToString(_ seconds: Int) -> String {
        var mins = 0
        var secs = seconds
        if seconds >= 60 {
            mins = Int(seconds / 60)
            secs = seconds - (mins * 60)
        }

        return String(format: "%02d:%02d", mins, secs)
    }
}

// MARK: Make constraints
private extension QuizesTableQuizCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20.scale),
            iconView.heightAnchor.constraint(equalToConstant: 22.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15.scale),
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 19.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 47.scale),
            titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 30.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 30.scale),
            arrowView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10.scale),
            arrowView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15.scale),
            scoreLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 56.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15.scale),
            timeLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 102.scale)
        ])
        
        NSLayoutConstraint.activate([
            averageTimeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -21.scale),
            averageTimeLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 102.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension QuizesTableQuizCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Review.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
