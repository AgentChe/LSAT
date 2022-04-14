//
//  Spinner.swift
//  EMT
//
//  Created by Андрей Чернышев on 11.04.2022.
//

import UIKit

final class Spinner: UIView {
    enum Style {
        case main, white
    }
    
    private let animationKey = "spinner_rotation_key"
    
    private lazy var isAnimating = false
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame.size = size
        view.image = UIImage(named: imageName())
        view.contentMode = .scaleAspectFit
        addSubview(view)
        return view
    }()
    
    private let size: CGSize
    private let style: Style
    
    init(size: CGSize, style: Style = .main) {
        self.size = size
        self.style = style
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isAnimating {
            stopAnimating()
            startAnimating()
        }
    }
}

// MARK: Public
extension Spinner {
    func startAnimating() {
        isHidden = false
        isAnimating = true
        
        guard imageView.layer.animation(forKey: animationKey) == nil else {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = Float.pi * 2
        animation.fromValue = 0
        animation.isCumulative = true
        animation.repeatCount = HUGE
        animation.duration = 2.5
        
        imageView.layer.add(animation, forKey: animationKey)
    }
    
    func stopAnimating() {
        isHidden = true
        isAnimating = false
        
        imageView.layer.removeAnimation(forKey: animationKey)
    }
}

// MARK: Private
private extension Spinner {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func imageName() -> String {
        switch style {
        case .main:
            return "Spinner.Main"
        case .white:
            return "Spinner.White"
        }
    }
}
