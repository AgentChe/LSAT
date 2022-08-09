//
//  SettingsExamCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import UIKit

final class SettingsExamCell: UITableViewCell {
    weak var tableDelegate: SettingsTableDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var container = makeContainer()
    lazy var courseButton = makeCourseButton()
    lazy var examDateButton = makeExamDateButton()
    lazy var resetProgressButton = makeResetProgressButton()
    lazy var resetProgressPreloader = makePreloader()
    
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
extension SettingsExamCell {
    func setup(element: SettingsExam) {
        courseButton.placeholderLabel.attributedText = element.course?.name
            .attributed(with: TextAttributes()
                        .textColor(Appearance.blackColor)
                        .font(Fonts.SFProRounded.semiBold(size: 17.scale))
                        .lineHeight(20.scale))
        
        
        let examDate = formattedExamDate(element.examDate)
        examDateButton.valueLabel.attributedText = examDate
            .attributed(with: TextAttributes()
                        .textColor(Appearance.mainColor)
                        .font(Fonts.SFProRounded.semiBold(size: 17.scale))
                        .lineHeight(20.scale))
        
        element.resetProgressActivity ? resetProgressPreloader.startAnimating() : resetProgressPreloader.stopAnimating()
        resetProgressButton.isHidden = element.resetProgressActivity
    }
}

// MARK: Private
private extension SettingsExamCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func formattedExamDate(_ date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        formatter.locale = Locale.current
        
        return formatter.string(from: date)
    }
    
    @objc
    func courseTapped() {
        tableDelegate?.settingsTableDidTappedCourse()
    }
    
    @objc
    func examDateTapped() {
        tableDelegate?.settingsTableDidTappedExamDate()
    }
    
    @objc
    func resetProgressTapped() {
        tableDelegate?.settingsTableDidTappedResetProgress()
    }
}

// MARK: Make constraints
private extension SettingsExamCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            courseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            courseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            courseButton.topAnchor.constraint(equalTo: container.topAnchor),
            courseButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            examDateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            examDateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            examDateButton.topAnchor.constraint(equalTo: courseButton.bottomAnchor),
            examDateButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            resetProgressButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            resetProgressButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            resetProgressButton.topAnchor.constraint(equalTo: examDateButton.bottomAnchor),
            resetProgressButton.heightAnchor.constraint(equalToConstant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            resetProgressPreloader.centerXAnchor.constraint(equalTo: resetProgressButton.centerXAnchor),
            resetProgressPreloader.centerYAnchor.constraint(equalTo: resetProgressButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsExamCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = "Settings.Exam".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCourseButton() -> SettingsArrowButton {
        let view = SettingsArrowButton()
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(courseTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeExamDateButton() -> SettingsArrowButton {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = SettingsArrowButton()
        view.placeholderLabel.attributedText = "Settings.Exam.ExamDateTitle".localized.attributed(with: attrs)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(examDateTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeResetProgressButton() -> SettingsArrowButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mainColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = SettingsArrowButton()
        view.placeholderLabel.attributedText = "Settings.Exam.ResetProgress".localized.attributed(with: attrs)
        view.layer.cornerRadius = 16.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.separator.isHidden = true
        view.arrowView.isHidden = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(resetProgressTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 24.scale, height: 24.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
