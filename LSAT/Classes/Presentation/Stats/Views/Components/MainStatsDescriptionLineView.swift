//
//  MainStatsDescriptionLineView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 25.01.2021.
//

import UIKit

class MainStatsDescriptionLineView: UIView {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var valueLabel = makeValueLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MainStatsDescriptionLineView {
    func setup(title: String, value: String) {
        let titleAttributes = TextAttributes()
            .font(Fonts.SFProRounded.bold(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
            .textColor(UIColor.black)
        
        let valueAttributes = TextAttributes()
            .font(Fonts.SFProRounded.bold(size: 17.scale))
            .lineHeight(20.scale)
            .textColor(Appearance.mainColor)
            .textAlignment(.right)
        
        titleLabel.attributedText = title.attributed(with: titleAttributes)
        valueLabel.attributedText = value.attributed(with: valueAttributes)
    }
}

// MARK: Make constraints
private extension MainStatsDescriptionLineView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.scale),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.scale),
            titleLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15.scale),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.scale),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MainStatsDescriptionLineView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
