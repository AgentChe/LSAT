//
//  SplashOnboardingNavigate.swift
//  Nursing
//
//  Created by Андрей Чернышев on 05.04.2022.
//

import RxSwift
import RxCocoa
import UIKit

final class SplashOnboardingNavigate {
    enum Progress {
        case error, downloading, complete
    }
    
    private var disposable: Disposable?
    
    private var handler: ((Progress) -> Void)?
    
    private weak var vc: UIViewController?
    private weak var viewModel: SplashViewModel?
    
    init(vc: UIViewController, viewModel: SplashViewModel) {
        self.vc = vc
        self.viewModel = viewModel
    }
}

// MARK: Public
extension SplashOnboardingNavigate {
    func navigate(handler: @escaping ((Progress) -> Void)) {
        self.handler = handler
        
        obtainTest()
    }
}

// MARK: Private
private extension SplashOnboardingNavigate {
    func obtainTest() {
        guard let viewModel = viewModel else {
            return
        }
        
        disposable?.dispose()
        
        send(progress: .downloading)
        
        disposable = viewModel.obtainOnboardingSet()
            .drive(onNext: { [weak self] test in
                guard let self = self else {
                    return
                }
                
                let success = test != nil
                
                if success {
                    self.send(progress: .complete)
                } else {
                    self.send(progress: .error)
                    self.openError()
                }
            })
    }
    
    func openError() {
        let tryAgainVC = TryAgainViewController.make { [weak self] in
            guard let self = self else {
                return
            }
            
            self.obtainTest()
        }
        vc?.present(tryAgainVC, animated: true)
    }
    
    func send(progress: Progress) {
        guard let handler = handler else {
            return
        }
        
        handler(progress)
    }
}
