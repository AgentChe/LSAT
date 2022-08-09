//
//  TimedQuizMinutesViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 01.06.2022.
//

import UIKit
import RxSwift

final class TimedQuizMinutesViewController: UIViewController {
    lazy var mainView = TimedQuizMinutesView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let didStart: ((Int) -> Void)
    
    private init(didStart: @escaping (Int) -> Void) {
        self.didStart = didStart
        
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
                base.animateDismiss {
                    base.dismiss(animated: false)
                }
            })
            .disposed(by: disposeBag)
        
        mainView.startButton.rx.tap
            .withLatestFrom(mainView.minutesSlider.rx.value)
            .bind(to: Binder(self) { base, minutes in
                let value = Int(minutes)
                
                base.animateDismiss {
                    base.dismiss(animated: false) {
                        base.didStart(value)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShow()
    }
}

// MARK: Make
extension TimedQuizMinutesViewController {
    static func make(didStart: @escaping (Int) -> Void) -> TimedQuizMinutesViewController {
        let vc = TimedQuizMinutesViewController(didStart: didStart)
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

// MARK: Private
private extension TimedQuizMinutesViewController {
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
        mainView.containerBottomConstraint.constant = ScreenSize.isIphoneXFamily ? 347.scale : 317.scale
        mainView.containerBottomConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.mainView.dimmedView.alpha = 0
            self?.mainView.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}
