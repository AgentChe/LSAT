//
//  OSlide4Cell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlideGoalCell: PaddingLabel {
    var isSelected = false {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideGoalCell {
    func initialize() {
        backgroundColor = UIColor.white
        
        layer.masksToBounds = true
        layer.cornerRadius = 20.scale
        
        topInset = 15.scale
        bottomInset = 15.scale
        leftInset = 20.scale
        rightInset = 20.scale
        
        textColor = Appearance.blackColor
        font = Fonts.SFProRounded.semiBold(size: 17.scale)
    }
    
    func update() {
        layer.borderWidth = isSelected ? 2.scale : 0
        layer.borderColor = isSelected ? Appearance.mainColor.cgColor : UIColor.white.cgColor
    }
}
