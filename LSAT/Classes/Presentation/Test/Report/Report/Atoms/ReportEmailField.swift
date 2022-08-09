//
//  ReportEmailField.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import UIKit

final class ReportEmailField: UIView {
    enum State {
        case none, error, focus
    }
    
    enum Constants {
        static let emailKey = "report_email_key"
    }
    
    lazy var iconView = makeIconView()
    lazy var textField = makeTextField()
    
    var isValid: (() -> Bool)? { didSet { reset() } }
    var editing: (() -> Void)? { didSet { reset() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ReportEmailField {
    func color(at state: State) {
        switch state {
        case .none:
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        case .error:
            layer.borderWidth = 3.scale
            layer.borderColor = Appearance.errorColor.cgColor
        case .focus:
            layer.borderWidth = 3.scale
            layer.borderColor = Appearance.mainColor.cgColor
        }
    }
    
    func updateIcon() {
        iconView.alpha = isEmpty() ? 0.5 : 1
    }
    
    func isEmpty() -> Bool {
        let text = textField.text ?? ""
        return text.isEmpty
    }
    
    func reset() {
        textField.text = UserDefaults.standard.string(forKey: Constants.emailKey)
        
        let isEmptyOrValid = isEmpty() || (isValid?() ?? true)
        color(at: isEmptyOrValid ? .none : .error)
        
        updateIcon()
        
        editing?()
    }
}

// MARK: UITextFieldDelegate
extension ReportEmailField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField === self.textField else {
            return
        }
        
        let isEmptyOrValid = isEmpty() || (isValid?() ?? true)
        color(at: isEmptyOrValid ? .focus : .error)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField === self.textField else {
            return
        }
        
        let isEmptyOrValid = isEmpty() || (isValid?() ?? true)
        color(at: isEmptyOrValid ? .none : .error)
        
        saveEmail()
    }
}

// MARK: Private
private extension ReportEmailField {
    func initialize() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(focusTextField))
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    @objc
    func focusTextField() {
        textField.becomeFirstResponder()
    }
    
    @objc
    func textEditing() {
        if isEmpty() || (isValid?() ?? true) {
            color(at: .focus)
        }
        
        updateIcon()
        
        editing?()
    }
    
    func saveEmail() {
        let email = textField.text ?? ""
        UserDefaults.standard.set(email, forKey: Constants.emailKey)
    }
}

// MARK: Make constraints
private extension ReportEmailField {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 19.75.scale),
            iconView.heightAnchor.constraint(equalToConstant: 15.44.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19.scale)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ReportEmailField {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Report.Email")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(24.scale)
            .textColor(Appearance.blackColor)
        
        let placeholderAttrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(24.scale)
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
        
        let view = PaddingTextField()
        view.delegate = self
        view.backgroundColor = UIColor.clear
        view.textPadding = UIEdgeInsets(top: 0, left: 48.scale, bottom: 0, right: 21.scale)
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "Report.Email".localized.attributed(with: placeholderAttrs)
        view.addTarget(self, action: #selector(textEditing), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
