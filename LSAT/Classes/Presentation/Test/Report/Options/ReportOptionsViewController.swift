//
//  ReportOptionsViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import UIKit
import RxSwift

protocol ReportOptionsViewControllerDelegate: AnyObject {
    func reportOptionsDidTappedReport(questionId: Int, userTestId: Int)
    func reportOptionsDidTappedRestart(userTestId: Int)
}

final class ReportOptionsViewController: UIViewController {
    weak var delegate: ReportOptionsViewControllerDelegate?
    
    lazy var mainView = ReportOptionsView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let questionId: Int
    private let userTestId: Int
    
    private init(questionId: Int, userTestId: Int) {
        self.questionId = questionId
        self.userTestId = userTestId
        
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
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.reportButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true) {
                    base.delegate?.reportOptionsDidTappedReport(questionId: base.questionId,
                                                                userTestId: base.userTestId)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.restartButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true) {
                    base.delegate?.reportOptionsDidTappedRestart(userTestId: base.userTestId)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension ReportOptionsViewController {
    static func make(questionId: Int, userTestId: Int) -> ReportOptionsViewController {
        let vc = ReportOptionsViewController(questionId: questionId, userTestId: userTestId)
        vc.modalPresentationStyle = .popover
        return vc
    }
}
