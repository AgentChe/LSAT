//
//  PassRateView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 24.01.2021.
//

import UIKit

class PassRateCell: UITableViewCell {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var containerView = makeContainerView()
    private lazy var progressView = makeProgressView()
    private lazy var percentLabel = makePercentLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PassRateCell {
    func setup(percent: Int) {
        percentLabel.attributedText = "\(percent)%".attributed(with: PassRateCell.textAttr)
        progressView.setProgress(min(Float(Double(percent) / 100), 1.0), animated: false)
    }
}

// MARK: Make constraints
private extension PassRateCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.scale),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.scale),
            titleLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -15.scale),
            titleLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.scale),
            progressView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20.scale),
            progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15.scale),
            progressView.heightAnchor.constraint(equalToConstant: 3.scale)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20.scale),
            percentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15.scale),
            percentLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PassRateCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.attributedText = "Stats.PassRate.Title".localized.attributed(with: PassRateCell.textAttr)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        view.progressTintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeContainerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.mainColor
        contentView.addSubview(view)
        return view
    }
    
    static let textAttr = TextAttributes()
        .textColor(.white)
        .font(Fonts.SFProRounded.bold(size: 21.scale))
        .lineHeight(25.scale)
}
