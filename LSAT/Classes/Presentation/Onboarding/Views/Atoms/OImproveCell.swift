//
//  OImproveCell.swift
//  FNP
//
//  Created by Andrey Chernyshev on 12.07.2021.
//

import UIKit

final class OImproveCell: CircleView {
    lazy var label = makeLabel()
    
    var isSelected = false {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OImproveCell {
    func update() {
        backgroundColor = isSelected ? Appearance.mainColor : UIColor.white
        label.textColor = isSelected ? UIColor.white : UIColor.black
    }
}

// MARK: Make constraints
private extension OImproveCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OImproveCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = Fonts.SFProRounded.semiBold(size: 17.scale)
        view.textColor = UIColor.black
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
