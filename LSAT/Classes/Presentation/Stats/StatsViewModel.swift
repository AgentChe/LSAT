//
//  StatsViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class StatsViewModel {
    private lazy var statsManager = StatsManagerCore()
    private lazy var courseManager = CoursesManagerCore()
    
    lazy var courseName = makeCourseName()
    lazy var elements = makeElements()
    
    lazy var activityIndicator = RxActivityIndicator()
    
    var tryAgain: ((Error) -> (Observable<Void>))?

    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension StatsViewModel {
    func makeCourseName() -> Driver<String> {
        courseManager
            .retrieveSelectedCourse()
            .compactMap { $0?.name }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeElements() -> Driver<[StatsCellType]> {
        guard let courseId = courseManager.getSelectedCourse()?.id else {
            return .just([])
        }
        
        return QuestionManagerMediator.shared.rxTestPassed
            .asObservable()
            .startWith(Void())
            .flatMapLatest { [weak self] _ -> Observable<Stats?> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Stats?> {
                    self.statsManager
                        .retrieveStats(courseId: courseId)
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
                    .trackActivity(self.activityIndicator)
            }
            .map { stats -> [StatsCellType] in
                guard let stats = stats else { return [] }
                let passRate: StatsCellType = .passRate(stats.passRate)
                let main: StatsCellType = .main(.init(stats: stats))
                
                return stats
                    .courseStats
                    .reduce(into: [passRate, main]) {
                        $0.append(.course(.init(courseStats: $1)))
                    }
            }
            .asDriver(onErrorJustReturn: [])
    }
}
