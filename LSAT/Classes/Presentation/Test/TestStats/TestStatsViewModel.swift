//
//  TestStatsViewModel.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 11.02.2021.
//

import RxSwift
import RxCocoa

final class TestStatsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var userTestId = BehaviorRelay<Int?>(value: nil)
    lazy var testType = BehaviorRelay<TestType?>(value: nil)
    lazy var filterRelay = PublishRelay<TestStatsFilter>()
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    lazy var courseName = makeCourseName()
    lazy var testName = makeTestName()
    
    private lazy var stats = makeStats()
    private lazy var course = makeCourse()
    
    private lazy var statsManager = StatsManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension TestStatsViewModel {
    func makeElements() -> Driver<[TestStatsCellType]> {
        Driver
            .combineLatest(stats, filterRelay.asDriver(onErrorDriveWith: .never()))
            .map { stats, filter -> [TestStatsCellType] in
                let initial: [TestStatsCellType] = [
                    .progress(.init(stats: stats)),
                    .description(.init(stats: stats)),
                    .filter(filter)
                ]
                
                return stats.questions
                    .reduce(into: initial) { old, question in
                        switch filter {
                        case .all:
                            old.append(.answer(question))
                        case .incorrect:
                            if !question.isCorrectly {
                                old.append(.answer(question))
                            } else {
                                break
                            }
                        case .correct:
                            if question.isCorrectly {
                                old.append(.answer(question))
                            } else {
                                break
                            }
                        }
                    }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeStats() -> Driver<TestStats> {
        Driver
            .combineLatest(
                userTestId
                    .compactMap { $0 }
                    .asDriver(onErrorDriveWith: .never()),
                
                course
                    .map { $0.id }
            )
            .flatMapLatest { [weak self] userTestId, courseId -> Driver<TestStats> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<TestStats> {
                    self.statsManager
                        .obtainTestStats(userTestId: userTestId, courseId: courseId, peek: true)
                        .flatMap { stats -> Single<TestStats> in
                            guard let stats = stats else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(stats)
                        }
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
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makeCourseName() -> Driver<String> {
        course.map { $0.name }
    }
    
    func makeCourse() -> Driver<Course> {
        profileManager
            .obtainSelectedCourse(forceUpdate: false)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeTestName() -> Driver<String> {
        testType
            .map { type -> String in
                switch type {
                case .get:
                    return "Study.TakeTest".localized
                case .tenSet:
                    return "Study.Mode.TenQuestions".localized
                case .failedSet:
                    return "Study.Mode.MissedQuestions".localized
                case .qotd:
                    return "Study.Mode.TodaysQuestion".localized
                case .randomSet:
                    return "Study.Mode.RandomSet".localized
                case .saved:
                    return "Study.Mode.Saved".localized
                case .timed:
                    return "Study.Mode.Timed".localized
                case .none:
                    return ""
                }
            }
            .asDriver(onErrorJustReturn: "")
    }
}


