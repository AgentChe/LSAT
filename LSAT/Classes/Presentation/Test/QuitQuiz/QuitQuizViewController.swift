//
//  QuitQuizViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 30.05.2022.
//

import UIKit
import RxSwift

final class QuitQuizViewController: UIViewController {
    enum Result {
        case quit, submit
    }
    
    lazy var mainView = QuitQuizView(allQuestionsCount: allQuestionsCount,
                                     answeredQuestionsCount: answeredQuestionsCount)
    
    private lazy var disposeBag = DisposeBag()
    
    private let allQuestionsCount: Int
    private let answeredQuestionsCount: Int
    private let completion: ((Result) -> Void)
    
    private init(allQuestionsCount: Int,
                 answeredQuestionsCount: Int,
                 completion: @escaping (Result) -> Void) {
        self.allQuestionsCount = allQuestionsCount
        self.answeredQuestionsCount = answeredQuestionsCount
        self.completion = completion
        
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
        
        Observable
            .merge(
                mainView.quitButton.rx.tap.map { Result.quit },
                mainView.submitButton.rx.tap.map { Result.submit }
            )
            .bind(to: Binder(self) { base, result in
                base.dismiss(result)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                mainView.closeButton.rx.tap.asObservable(),
                mainView.continueButton.rx.tap.asObservable()
            )
            .bind(to: Binder(self) { base, void in
                base.dismiss()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShow()
    }
}

// MARK: Make
extension QuitQuizViewController {
    static func make(allQuestionsCount: Int,
                     answeredQuestionsCount: Int,
                     completion: @escaping (Result) -> Void) -> QuitQuizViewController {
        let vc = QuitQuizViewController(allQuestionsCount: allQuestionsCount,
                                        answeredQuestionsCount: answeredQuestionsCount,
                                        completion: completion)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension QuitQuizViewController {
    func animateShow() {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 0
        mainView.containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0.6
            self?.mainView.layoutIfNeeded()
        })
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = ScreenSize.isIphoneXFamily ? 370.scale : 330.scale
        mainView.containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0
            self?.mainView.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
    
    func dismiss(_ result: Result) {
        animateDismiss { [weak self] in
            self?.dismiss(animated: false) {
                self?.completion(result)
            }
        }
    }
    
    func dismiss() {
        animateDismiss { [weak self] in
            self?.dismiss(animated: false)
        }
    }
}
