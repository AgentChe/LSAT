//
//  QuizesViewModel.swift
//  Nursing
//
//  Created by Андрей Чернышев on 18.06.2022.
//

import RxSwift
import RxCocoa

final class QuizesViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var timelines = makeTimelines()
    private lazy var course = makeCourse()
    
    private lazy var profileManager = ProfileManager()
    private lazy var statsManager = StatsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension QuizesViewModel {
    func makeElements() -> Driver<[QuizesTableElement]> {
        timelines.map { timelines -> [QuizesTableElement] in
            timelines.enumerated().reduce([]) { old, args -> [QuizesTableElement] in
                let (index, timeline) = args
                
                let quizes = timeline.quizes
                
                guard !quizes.isEmpty else {
                    return old
                }
                
                let dayElement: [QuizesTableElement] = [
                    .day(timeline.day),
                    .offset(15.scale)
                ]
                
                let quizesElement = quizes.enumerated().reduce([]) { old, args -> [QuizesTableElement] in
                    let (index, quiz) = args
                    
                    guard let element = QuizesTableQuiz(quiz: quiz) else {
                        return old
                    }
                    
                    var result: [QuizesTableElement] = [.quiz(element)]
                    
                    if (quizes.count - 1) != index {
                        result.append(.offset(13.scale))
                    }
                    
                    return old + result
                }
                
                let bottomOffsetElement: [QuizesTableElement] = (timelines.count - 1) == index ? [] : [.offset(30.scale)]
                
                let newElements = dayElement + quizesElement + bottomOffsetElement
                
                return old + newElements
            }
        }
    }
    
    func makeTimelines() -> Driver<[ReviewQuizTimeline]> {
        let triggers = Driver
            .combineLatest(
                course,
                QuestionMediator.shared.testPassed
                    .startWith(Void())
                    .asDriver(onErrorDriveWith: .never())
            ) { course, void -> Course in
                course
            }
        
        return triggers
            .flatMapLatest { [weak self] course -> Driver<[ReviewQuizTimeline]> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<[ReviewQuizTimeline]> {
                    self.statsManager
                        .obtainReviewQuizesTimelines(courseId: course.id)
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
                    .asDriver(onErrorJustReturn: [])
            }
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
