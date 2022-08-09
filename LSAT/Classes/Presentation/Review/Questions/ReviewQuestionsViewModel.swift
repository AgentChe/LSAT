//
//  ReviewQuestionsViewModel.swift
//  Nursing
//
//  Created by Андрей Чернышев on 19.06.2022.
//

import RxSwift
import RxCocoa

final class ReviewQuestionsViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var filter = PublishRelay<ReviewQuestionsFilter>()
    lazy var nextPage = PublishRelay<Void>()
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var currentFilter = makeCurrentFilter()
    private lazy var course = makeCourse()
    
    private lazy var profileManager = ProfileManager()
    private lazy var questionManager = QuestionManager()
    
    private lazy var paginationLoader = ReviewQuestionsLoader(nextPage: nextPage.asObservable())
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension ReviewQuestionsViewModel {
    func makeElements() -> Driver<[ReviewQuestionsTableElement]> {
        let passTestTrigger = QuestionMediator.shared.testPassed
            .asDriver(onErrorDriveWith: .never())
            .startWith(Void())
         
        return Driver
            .combineLatest(course, currentFilter, passTestTrigger)
            .flatMapLatest { [weak self] args -> Driver<[Review]> in
                guard let self = self else {
                    return .never()
                }
                
                let (course, filter, _) = args
                
                return self.makeLoader(courseId: course.id,
                                       filter: filter)
                    .scan([]) { $0 + $1 }
            }
            .map { reviews -> [ReviewQuestionsTableElement] in
                var result = [ReviewQuestionsTableElement]()
                
                reviews.enumerated().forEach { index, review in
                    result.append(.review(review))
                    
                    if index != (reviews.count - 1) {
                        result.append(.offset(12.scale))
                    }
                }
                
                return result
            }
    }
    
    func makeLoader(courseId: Int, filter: Int) -> Driver<[Review]> {
        paginationLoader.load { [weak self] page -> Observable<Page<Review>> in
            guard let self = self else {
                return .empty()
            }
            
            func source() -> Single<Page<Review>> {
                self.questionManager
                    .obtainReview(courseId: courseId, mode: filter, offset: page * 20)
                    .map { Page(page: page, data: $0) }
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
    }
    
    func makeCurrentFilter() -> Driver<Int> {
        filter
            .map { filter -> Int in
                switch filter {
                case .all: return 0
                case .incorrect: return 1
                case .correct: return 2
                }
            }
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeCourse() -> Driver<Course> {
        let initial = profileManager
            .obtainSelectedCourse(forceUpdate: false)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .never())
        
        let updated = ProfileMediator.shared
            .changedCourse
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(initial, updated)
    }
}
