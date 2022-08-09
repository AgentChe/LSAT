//
//  TryAgainViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 31.03.2022.
//

import UIKit
import RxSwift

protocol TryAgainViewControllerDelegate: AnyObject {
    func tryAgainDidTapped()
}

final class TryAgainViewController: UIViewController {
    weak var delegate: TryAgainViewControllerDelegate?
    
    lazy var mainView = TryAgainView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let tryAgain: (() -> Void)?
    
    private init(tryAgain: (() -> Void)?) {
        self.tryAgain = tryAgain
        
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
        
        mainView.tryAgainButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.dismiss(animated: true) {
                    self.delegate?.tryAgainDidTapped()
                    self.tryAgain?()
                }
            })
            .disposed(by: disposeBag)
        
        mainView.contactButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.openContactUs()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TryAgainViewController {
    static func make(tryAgain: (() -> Void)? = nil) -> TryAgainViewController {
        TryAgainViewController(tryAgain: tryAgain)
    }
}

// MARK: Private
private extension TryAgainViewController {
    func openContactUs() {
        var parameters: [(String, String)]?
        
        if let userId = SessionManager().getSession()?.userId {
            parameters = [("user_id", String(userId))]
        }
        
        guard let url = URL(path: GlobalDefinitions.contactUsUrl, parameters: parameters ?? []) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
}
