//
//  ReviewFilterButton.swift
//  Nursing
//
//  Created by Андрей Чернышев on 17.06.2022.
//

import UIKit

final class ReviewFilterButton: UIButton {
    enum Mode {
        case selected, deselected
    }
    
    var mode = Mode.deselected {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    
    private let text: String
    
    init(text: String) {
        self.text = text
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ReviewFilterButton {
    func update() {
        let attrs = TextAttributes()
            .textColor(mode == .selected ? Appearance.mainColor : UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(23.8.scale)
            .textAlignment(.center)
        label.attributedText = text.attributed(with: attrs)
        
        backgroundColor = mode == .selected ? UIColor.white : UIColor.clear
    }
}

// MARK: Make constraints
private extension ReviewFilterButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ReviewFilterButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
