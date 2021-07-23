//
//  OStepView.swift
//  FNP
//
//  Created by Andrey Chernyshev on 11.07.2021.
//

import UIKit

final class OStepView: UIView {
    lazy var count = 0 {
        didSet {
            createViews()
        }
    }
    
    lazy var step = 0 {
        didSet {
            fillViews()
        }
    }
    
    lazy var views = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createViews()
        fillViews()
    }
}

// MARK: Private
private extension OStepView {
    func createViews() {
        views.forEach { $0.removeFromSuperview() }
        views = []

        let margin = 7.scale
        let totalMargin = margin * CGFloat((count - 1))

        let totalWidth = frame.width - totalMargin
        let width = totalWidth / CGFloat(count)

        var x = CGFloat(0)

        for _ in 0...count - 1 {
            let view = UIView()
            view.frame.size = CGSize(width: width, height: frame.height)
            view.frame.origin = CGPoint(x: x, y: 0)
            view.layer.cornerRadius = 2.5.scale
            addSubview(view)

            views.append(view)

            x += width + margin
        }
    }
    
    func fillViews() {
        views.forEach {
            $0.backgroundColor = Appearance.progress3Color.withAlphaComponent(0.1)
        }
        
        views.prefix(step).forEach {
            $0.backgroundColor = Appearance.mainColor
        }
    }
}
