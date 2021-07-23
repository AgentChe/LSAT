//
//  WelcomeSlideIndicatorView.swift
//  FNP
//
//  Created by Andrey Chernyshev on 09.07.2021.
//

import UIKit

final class WelcomeSlideIndicatorView: UIView {
    lazy var index = 1 {
        didSet {
            update()
        }
    }
    
    lazy var indicator1View = makeIndicatorView()
    lazy var indicator2View = makeIndicatorView()
    lazy var indicator3View = makeIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        update()
    }
}

// MARK: Private
private extension WelcomeSlideIndicatorView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        indicator1View.frame.origin = CGPoint(x: 162.scale, y: 0)
        indicator2View.frame.origin = CGPoint(x: 182.scale, y: 0)
        indicator3View.frame.origin = CGPoint(x: 202.scale, y: 0)
    }
    
    func update() {
        indicator1View.backgroundColor = Appearance.progress3Color.withAlphaComponent(index == 1 ? 1 : 0.2)
        indicator2View.backgroundColor = Appearance.progress3Color.withAlphaComponent(index == 2 ? 1 : 0.2)
        indicator3View.backgroundColor = Appearance.progress3Color.withAlphaComponent(index == 3 ? 1 : 0.2)
    }
}

// MARK: Lazy initialization
private extension WelcomeSlideIndicatorView {
    func makeIndicatorView() -> UIView {
        let view = UIView()
        view.frame.size = CGSize(width: 10.scale, height: 10.scale)
        view.layer.cornerRadius = 5.scale
        addSubview(view)
        return view
    }
}
