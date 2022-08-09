//
//  TextSizeAnswerView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 25.05.2022.
//

import UIKit

final class TextSizeAnswerView: UIView {
    lazy var label = makeLabel()
    
    private let text: String
    
    init(text: String) {
        self.text = text
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TextSizeAnswerView {
    func setup(textSize: TextSize) {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.regular(size: textSize.answerFontSize))
            .lineHeight(textSize.answerLineHeight)
        label.attributedText = text.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension TextSizeAnswerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TextSizeAnswerView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
