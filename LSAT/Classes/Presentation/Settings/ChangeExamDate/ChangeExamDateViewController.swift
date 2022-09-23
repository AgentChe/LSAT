//
//  ChangeExamDateViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 24.05.2022.
//

import UIKit
import RxSwift

final class ChangeExamDateViewController: UIViewController {
    lazy var mainView = ChangeExamDateView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = ChangeExamDateViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "When Exam Screen", parameters: [:])
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.currentDate
            .drive(onNext: { [weak self] date in
                guard let self = self, let date = date else {
                    return
                }
                
                self.mainView.datePickerView.date = date
            })
            .disposed(by: disposeBag)
        
        mainView.button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                let date = self.mainView.datePickerView.date
                self.viewModel.new.accept(date)
            })
            .disposed(by: disposeBag)
        
        viewModel.saved
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(onNext: { [weak self] activity in
                self?.mainView.activity(activity)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension ChangeExamDateViewController {
    static func make() -> ChangeExamDateViewController {
        let vc = ChangeExamDateViewController()
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: Private
private extension ChangeExamDateViewController {
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
}
