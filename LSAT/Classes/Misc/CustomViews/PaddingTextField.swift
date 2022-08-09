//
//  PaddingTextField.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import  UIKit

class PaddingTextField: UITextField {
    var textPadding = UIEdgeInsets(
        top: 10.scale,
        left: 20.scale,
        bottom: 10.scale,
        right: 20.scale
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
