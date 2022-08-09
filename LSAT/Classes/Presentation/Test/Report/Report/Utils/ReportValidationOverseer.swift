//
//  ReportValidationOverseer.swift
//  Nursing
//
//  Created by Андрей Чернышев on 28.05.2022.
//

final class ReportValidationOverseer {
    private let mainView: ReportView
    
    private var handler: ((Bool) -> Void)?
    
    init(mainView: ReportView) {
        self.mainView = mainView
    }
}

// MARK: Public
extension ReportValidationOverseer {
    func startValidation() {
        mainView.emailField.isValid = { [weak self] in
            guard let self = self else {
                return true
            }
            
            guard !self.mainView.emailField.isHidden else {
                return true
            }
            
            let email = self.mainView.emailField.textField.text ?? ""
            
            guard !email.isEmpty else {
                return true
            }
            
            return EmailRegex().isValid(email: email)
        }
    }
}
