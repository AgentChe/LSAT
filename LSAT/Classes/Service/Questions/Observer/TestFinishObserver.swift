//
//  TestFinishObserver.swift
//  Nursing
//
//  Created by Андрей Чернышев on 02.06.2022.
//

import RxSwift
import RxCocoa

final class TestFinishObserver {
    static let shared = TestFinishObserver()
    
    private init() {}
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var questionManager = QuestionManager()
}

// MARK: Public
extension TestFinishObserver {
    func startObserve() {
        QuestionMediator.shared
            .testClosed
            .filter { element -> Bool in
                guard case .timed = element.testType else {
                    return false
                }
                
                return true
            }
            .flatMapLatest { [weak self] element -> Signal<Void> in
                guard let self = self else {
                    return .never()
                }
                
                return self.questionManager
                    .finishTest(userTestId: element.userTestId)
                    .asSignal(onErrorSignalWith: .never())
            }
            .emit()
            .disposed(by: disposeBag)
    }
}
