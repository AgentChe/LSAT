//
//  SCTakeTestCell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 31.01.2021.
//

import UIKit

final class SCTakeTestCell: UICollectionViewCell {
    lazy var button = makeButton()
    
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
extension SCTakeTestCell {
    func setup(activeSubscription: Bool) {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.bold(size: 19.scale))
        let text = activeSubscription ? "Study.TakeTest".localized : "Study.TakeFreeTest".localized
        button.setAttributedTitle(text.attributed(with: attrs), for: .normal)
        
        button.backgroundColor = activeSubscription ? Appearance.mainColor : Appearance.thirdColor
    }
}

// MARK: Private
private extension SCTakeTestCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension SCTakeTestCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SCTakeTestCell {
    func makeButton() -> UIButton {
        let view = UIButton()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 30.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
