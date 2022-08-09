//
//  ReportViewModel.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import RxSwift
import RxCocoa

final class ReportViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var report = PublishRelay<ReportScope>()
    
    lazy var reported = makeReported()
    lazy var activity = RxActivityIndicator()
    
    private lazy var questionManager = QuestionManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension ReportViewModel {
    func makeReported() -> Driver<Void> {
        report
            .flatMapLatest { [weak self] scope -> Observable<Void> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<Void> {
                    self.questionManager
                        .report(questionId: scope.questionId,
                                reason: scope.reason.code(),
                                email: scope.email,
                                comment: scope.message)
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
