//
//  TestStatsDescriptionView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import UIKit

class TestStatsDescriptionView: UIView {
        
    private lazy var stackView = makeStackView()
    private lazy var testTimeLineView = makeLineView()
    private lazy var communityAverageLineView = makeLineView()
    private lazy var averageScoreLineView = makeLineView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TestStatsDescriptionView {
    func setup(element: TestStatsDescriptionElement) {
        testTimeLineView.setup(title: "TestStats.TestTime".localized, value: element.userTime)
        communityAverageLineView.setup(title: "TestStats.CommunityAverage".localized, value: element.communityTime)
        averageScoreLineView.setup(title: "TestStats.AverageScore".localized, value: "\(element.communityScore) %")
    }
}

// MARK: Private
private extension TestStatsDescriptionView {
    func configure() {
        layer.cornerRadius = 20.scale
        [testTimeLineView, makeSeparatorView(), communityAverageLineView, makeSeparatorView(), averageScoreLineView].forEach(stackView.addArrangedSubview)
    }
}

// MARK: Make constraints
private extension TestStatsDescriptionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsDescriptionView {
    func makeLineView() -> MainStatsDescriptionLineView {
        let view = MainStatsDescriptionLineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mainColor.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.scale).isActive = true
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
