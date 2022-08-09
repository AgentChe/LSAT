//
//  StatsViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class StatsViewModel {
    lazy var courseName = makeCourseName()
    lazy var elements = makeElements()
    
    lazy var activityIndicator = RxActivityIndicator()
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var course = makeCourse()
    
    private lazy var statsManager = StatsManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension StatsViewModel {
    func makeCourseName() -> Driver<String> {
        course
            .compactMap { $0?.name }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeElements() -> Driver<[StatsCellType]> {
        let trigger = Signal
            .merge(
                QuestionMediator.shared.testPassed,
                StatsMediator.shared.resetedStats
            )
            .asDriver(onErrorDriveWith: .never())
            .startWith(())
        
        return Driver
            .combineLatest(trigger, course) { $1 }
            .compactMap { $0 }
            .asObservable()
            .flatMapLatest { [weak self] course -> Observable<Stats?> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Stats?> {
                    self.statsManager
                        .obtainStats(courseId: course.id)
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
    
    func makeCourse() -> Driver<Course?> {
        let initial = profileManager
            .obtainSelectedCourse(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedCourse
            .map { course -> Course? in
                course
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Driver.merge(initial, updated)
    }
}
