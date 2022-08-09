//
//  ReportEditingOverseer.swift
//  Nursing
//
//  Created by Андрей Чернышев on 28.05.2022.
//

final class ReportEditingOverseer {
    private let mainView: ReportView
    
    private var handler: ((Bool) -> Void)?
    
    init(mainView: ReportView) {
        self.mainView = mainView
        
        checkAvailable()
    }
}

// MARK: Public
extension ReportEditingOverseer {
    func subscribe(handler: @escaping (Bool) -> Void) {
        self.handler = handler
        
        mainView.emailField.editing = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.checkAvailable()
        }
        
        mainView.messageView.editing = { [weak self] in
            self?.checkAvailable()
        }
        
        checkAvailable()
    }
}

// MARK: Private
private extension ReportEditingOverseer {
    func checkAvailable() {
        let emailValid = mainView.emailField.isValid?() ?? true
        let messageValid = !mainView.messageView.textView.text.isEmpty
        
        let isValid = emailValid && messageValid
        
        handler?(isValid)
    }
}
