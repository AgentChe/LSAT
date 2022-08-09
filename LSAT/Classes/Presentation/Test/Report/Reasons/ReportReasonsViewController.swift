//
//  ReportReasonsViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import UIKit
import RxSwift

protocol ReportReasonsViewControllerDelegate: AnyObject {
    func reportReasonDidTappedBack(questionId: Int, userTestId: Int)
    func reportReasonDidSelected(questionId: Int, userTestId: Int, reason: ReportReason)
}

final class ReportReasonsViewController: UIViewController {
    weak var delegate: ReportReasonsViewControllerDelegate?
    
    lazy var mainView = ReportReasonsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let questionId: Int
    private let userTestId: Int
    private let reason: ReportReason?
    
    private init(questionId: Int, userTestId: Int, reason: ReportReason?) {
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
        
        mainView.backButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true) {
                    base.delegate?.reportReasonDidTappedBack(questionId: base.questionId,
                                                             userTestId: base.userTestId)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                mainView.reason1Button.rx.tap
                    .map { ReportReason.answerIsWrong },
                mainView.reason2Button.rx.tap
                    .map { ReportReason.caughtTypo },
                mainView.reason3Button.rx.tap
                    .map { ReportReason.confusing },
                mainView.reason4Button.rx.tap
                    .map { ReportReason.notWorking }
            )
            .bind(to: Binder(self) { base, reason in
                base.dismiss(animated: true) {
                    base.delegate?.reportReasonDidSelected(questionId: base.questionId,
                                                           userTestId: base.userTestId,
                                                           reason: reason)
                }
            })
            .disposed(by: disposeBag)
        
        setupInitial()
    }
}

// MARK: Make
extension ReportReasonsViewController {
    static func make(questionId: Int, userTestId: Int, reason: ReportReason?) -> ReportReasonsViewController {
        let vc = ReportReasonsViewController(questionId: questionId,
                                             userTestId: userTestId,
                                             reason: reason)
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: Private
private extension ReportReasonsViewController {
    func setupInitial() {
        guard let reason = reason else {
            return
        }
        
        update(selected: reason)
    }
    
    func update(selected reason: ReportReason) {
        let views = [
            mainView.reason1Button,
            mainView.reason2Button,
            mainView.reason3Button,
            mainView.reason4Button
        ]
        
        views.forEach { $0.isChecked = $0.reason == reason }
    }
}
