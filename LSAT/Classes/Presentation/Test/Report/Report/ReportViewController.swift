//
//  ReportViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import UIKit
import RxSwift

protocol ReportViewControllerDelegate: AnyObject {
    func reportViewControllerDidTappedBack(questionId: Int, userTestId: Int, reason: ReportReason)
    func reportViewControllerDidReported()
}

final class ReportViewController: UIViewController {
    weak var delegate: ReportViewControllerDelegate?
    
    lazy var mainView = ReportView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = ReportViewModel()
    
    private lazy var validationOverseer = ReportValidationOverseer(mainView: mainView)
    private lazy var editingOverseer = ReportEditingOverseer(mainView: mainView)
    
    private let questionId: Int
    private let userTestId: Int
    private let reason: ReportReason
    
    private init(questionId: Int, userTestId: Int, reason: ReportReason) {
        self.questionId = questionId
        self.userTestId = userTestId
        self.reason = reason
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        viewModel.reported
            .drive(Binder(self) { base, void in
                base.dismiss(animated: true) {
                    base.delegate?.reportViewControllerDidReported()
                }
            })
            .disposed(by: disposeBag)
        
        mainView.backButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true) {
                    base.delegate?.reportViewControllerDidTappedBack(questionId: base.questionId,
                                                                     userTestId: base.userTestId,
                                                                     reason: base.reason)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.rx.keyboardHeight
            .bind(to: Binder(self) { base, keyboardHeight in
                base.mainView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            })
            .disposed(by: disposeBag)
        
        mainView.reportButton.rx.tap
            .compactMap { [weak self] void -> ReportScope? in
                self?.makeScope()
            }
            .bind(to: viewModel.report)
            .disposed(by: disposeBag)
        
        addHideKeyboardAction()
        validationOverseer.startValidation()
        editingOverseer.subscribe { [weak self] available in
            self?.update(available: available)
        }
        mainView.feedbackSwitch.setOn(false, animated: false)
    }
}

// MARK: Make
extension ReportViewController {
    static func make(questionId: Int, userTestId: Int, reason: ReportReason) -> ReportViewController {
        let vc = ReportViewController(questionId: questionId, userTestId: userTestId, reason: reason)
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: Private
private extension ReportViewController {
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
        mainView.reportButton.isHidden = activity
    }
    
    func addHideKeyboardAction() {
        let tapGesture = UITapGestureRecognizer()
        mainView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind(to: Binder(self) { base, event in
                base.mainView.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    func update(available: Bool) {
        mainView.reportButton.isUserInteractionEnabled = available
        mainView.reportButton.alpha = available ? 1 : 0.2
    }
    
    func makeScope() -> ReportScope? {
        guard
            let email = mainView.emailField.textField.text,
            let message = mainView.messageView.textView.text
        else {
            return nil
        }
        
        return ReportScope(questionId: questionId,
                           reason: reason,
                           email: email,
                           message: message)
    }
}
