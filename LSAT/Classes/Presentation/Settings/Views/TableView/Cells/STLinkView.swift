//
//  STLinkView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 26.01.2021.
//

import UIKit

final class STLinkView: UIView {
    lazy var label = makeLabel()
    lazy var arrowIcon = makeArrowIcon()
    lazy var placeholder = makePlaceholder()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension STLinkView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowIcon.widthAnchor.constraint(equalToConstant: 6.scale),
            arrowIcon.heightAnchor.constraint(equalToConstant: 12.scale),
            arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeholder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            placeholder.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholder.bottomAnchor.constraint(equalTo: bottomAnchor),
            placeholder.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension STLinkView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.font = Fonts.SFProRounded.semiBold(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowIcon() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Settings.Right")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlaceholder() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 196, green: 196, blue: 196)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
