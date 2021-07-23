//
//  TestStatsProgressCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import UIKit

class TestStatsProgressCell: UITableViewCell {

    lazy var progressView = makeProgressView()
    lazy var percentLabel = makePercentLabel()
    lazy var answerLabel = makeAnswersLabel()

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
extension TestStatsProgressCell {
    func setup(element: TestStatsProgressElement) {
        let progress = min(CGFloat(element.percent) / 100, 1)
        progressView.progress(progress: progress)
        percentLabel.text = "\(element.percent) %"
        answerLabel.text = String(format: "TestStats.QuestionsStats".localized, element.correctNumbers, element.incorrectNumbers)
    }
}

// MARK: Private
private extension TestStatsProgressCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TestStatsProgressCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25.scale),
            progressView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 194.scale),
            progressView.widthAnchor.constraint(equalToConstant: 194.scale)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            percentLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            percentLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            answerLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 5.scale),
            answerLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            answerLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsProgressCell {
    func makeProgressView() -> TestStatsProgressView {
        let view = TestStatsProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .center
        view.font = Fonts.SFProRounded.bold(size: 45.scale)
        view.textColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeAnswersLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .center
        view.font = Fonts.SFProRounded.regular(size: 17.scale)
        view.textColor = UIColor.black
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
