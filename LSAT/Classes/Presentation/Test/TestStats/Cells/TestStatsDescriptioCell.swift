//
//  TestStatsDescriptioCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 12.02.2021.
//

import UIKit

class TestStatsDescriptioCell: UITableViewCell {
    
    private lazy var descriptionView = makeDescriptionView()
    
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
extension TestStatsDescriptioCell {
    func setup(element: TestStatsDescriptionElement) {
        descriptionView.setup(element: element)
    }
}

// MARK: Private
private extension TestStatsDescriptioCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TestStatsDescriptioCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            descriptionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.scale),
            descriptionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.scale),
            descriptionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TestStatsDescriptioCell {
    func makeDescriptionView() -> TestStatsDescriptionView {
        let view = TestStatsDescriptionView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
