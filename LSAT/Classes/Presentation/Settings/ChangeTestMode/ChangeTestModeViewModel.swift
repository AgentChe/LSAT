//
//  ChangeTestModeViewModel.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.05.2022.
//

import RxSwift
import RxCocoa

final class ChangeTestModeViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var new = PublishRelay<TestMode>()
    
    lazy var currentTestMode = makeCurrentTestMode()
    lazy var saved = makeSaved()
    lazy var activity = RxActivityIndicator()
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension ChangeTestModeViewModel {
    func makeCurrentTestMode() -> Driver<TestMode?> {
        profileManager
            .obtainTestMode(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeSaved() -> Driver<Void> {
        new
            .flatMapLatest { [weak self] testMode -> Observable<Void> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<Void> {
                    self.profileManager
                        .set(testMode: testMode)
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
