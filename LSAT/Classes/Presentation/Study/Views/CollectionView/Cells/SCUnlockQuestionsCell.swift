//
//  SCUnlockQuestionsCell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 31.01.2021.
//

import UIKit

final class SCUnlockQuestionsCell: UICollectionViewCell {
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

// MARK: Private
private extension SCUnlockQuestionsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension SCUnlockQuestionsCell {
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
private extension SCUnlockQuestionsCell {
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.bold(size: 19.scale))
        
        let view = UIButton()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = Appearance.mainColor
        view.setAttributedTitle("Study.UnlockQuestions".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
