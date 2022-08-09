//
//  ChangeTestModeViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import UIKit
import RxSwift

final class ChangeTestModeViewController: UIViewController {
    lazy var mainView = ChangeTestModeView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = ChangeTestModeViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SDKStorage.shared.amplitudeManager
            .logEvent(name: "Exam Mode Screen", parameters: [:])
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        viewModel.currentTestMode
            .drive(onNext: { [weak self] testMode in
                guard let self = self, let testMode = testMode else {
                    return
                }
                
                self.mainView.setup(mode: testMode)
            })
            .disposed(by: disposeBag)
        
        mainView.button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                let cells = [
                    self.mainView.fullSupportCell,
                    self.mainView.withoutExplanationsCell,
                    self.mainView.examStyleCell
                ]
                
                guard let testModeCode = cells.first(where: { $0.isSelected })?.tag else {
                    return
                }
                
                guard let testMode = TestMode(code: testModeCode) else {
                    return
                }
                
                self.logAnalytics(testMode)
                self.viewModel.new.accept(testMode)
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
extension ChangeTestModeViewController {
    static func make() -> ChangeTestModeViewController {
        let vc = ChangeTestModeViewController()
        vc.modalPresentationStyle = .popover
        return vc
    }
}

// MARK: Private
private extension ChangeTestModeViewController {
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
    
    func logAnalytics(_ mode: TestMode) {
        switch mode {
        case .fullComplect:
            SDKStorage.shared.amplitudeManager
                .logEvent(name: "Exam Mode Tap", parameters: ["what": "full support"])
        case .noExplanations:
            SDKStorage.shared.amplitudeManager
                .logEvent(name: "Exam Mode Tap", parameters: ["what": "without explanations"])
        case .onAnExam:
            SDKStorage.shared.amplitudeManager
                .logEvent(name: "Exam Mode Tap", parameters: ["what": "exam style"])
        }
    }
}
