//
//  ChangeExamDateViewModel.swift
//  Nursing
//
//  Created by Андрей Чернышев on 24.05.2022.
//

import RxSwift
import RxCocoa

final class ChangeExamDateViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var new = PublishRelay<Date>()
    
    lazy var currentDate = makeCurrentDate()
    lazy var saved = makeSaved()
    lazy var activity = RxActivityIndicator()
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension ChangeExamDateViewModel {
    func makeCurrentDate() -> Driver<Date?> {
        profileManager
            .obtainDateOfExam(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeSaved() -> Driver<Void> {
        new
            .flatMapLatest { [weak self] date -> Observable<Void> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<Void> {
                    self.profileManager
                        .set(examDate: date)
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
