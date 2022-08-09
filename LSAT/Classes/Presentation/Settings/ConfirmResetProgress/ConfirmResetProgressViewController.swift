//
//  ConfirmResetProgressViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 24.05.2022.
//

import UIKit
import RxSwift

final class ConfirmResetProgressViewController: UIViewController {
    lazy var mainView = ConfirmResetProgressView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let completion: ((Bool) -> Void)
    
    private init(completion: @escaping (Bool) -> Void) {
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
                mainView.resetButton.rx.tap.map { true },
                mainView.closeButton.rx.tap.map { false },
                mainView.cancelButton.rx.tap.map { false }
            )
            .subscribe(onNext: { [weak self] result in
                self?.dismiss(result)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShow()
    }
}

// MARK: Make
extension ConfirmResetProgressViewController {
    static func make(completion: @escaping (Bool) -> Void) -> ConfirmResetProgressViewController {
        let vc = ConfirmResetProgressViewController(completion: completion)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension ConfirmResetProgressViewController {
    func animateShow() {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 0
        mainView.containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0.6
            self?.mainView.layoutIfNeeded()
        })
    }
    
    func dismiss(_ result: Bool) {
        animateDismiss { [weak self] in
            self?.dismiss(animated: false) {
                self?.completion(result)
            }
        }
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        mainView.containerBottomConstraint.isActive = false
        mainView.containerBottomConstraint.constant = 322.scale
        mainView.containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0
            self?.mainView.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}
