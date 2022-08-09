//
//  ReviewQuestionsFilterButton.swift
//  Nursing
//
//  Created by Андрей Чернышев on 19.06.2022.
//

import UIKit

final class ReviewQuestionsFilterButton: TapAreaButton {
    lazy var separator = makeSeparator()
    
    var isChecked: Bool = false {
        didSet {
            update()
        }
    }
    
    private let title: String
    
    init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ReviewQuestionsFilterButton {
    func update() {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .letterSpacing(-0.14.scale)
        let selectedAttrs = attrs.textColor(Appearance.mainColor)
        let unselectedAttrs = attrs.textColor(Appearance.mainColor.withAlphaComponent(0.4))
        let string = title.attributed(with: isChecked ? selectedAttrs : unselectedAttrs)
        setAttributedTitle(string, for: .normal)
        
        separator.isHidden = !isChecked
    }
}

// MARK: Make constraints
private extension ReviewQuestionsFilterButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 2.scale),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ReviewQuestionsFilterButton {
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
