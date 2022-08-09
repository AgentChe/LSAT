//
//  QuestionViewerViewModel.swift
//  Nursing
//
//  Created by Андрей Чернышев on 20.06.2022.
//

import RxSwift
import RxCocoa

final class QuestionViewerViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    let didTapMark = PublishRelay<Bool>()
    let didTapPrevious = PublishRelay<Int>()
    let didTapNext = PublishRelay<Int>()
    
    lazy var isSavedQuestion = makeIsSavedQuestion()
    lazy var elements = makeElements()
    lazy var score = makeScore()
    lazy var currentIndex = makeCurrentIndex()
    
    private lazy var textSize = makeTextSize()
    private lazy var answeredIds = makeAnsweredIds()
    private lazy var question = makeQuestion()
    private lazy var review = makeReview()
    
    private let reviews: BehaviorRelay<[Review]>
    private let initialReview: BehaviorRelay<Review>
    
    private lazy var questionManager = QuestionManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(reviews: [Review], current: Review) {
        self.reviews = BehaviorRelay(value: reviews)
        self.initialReview = BehaviorRelay(value: current)
    }
}

// MARK: Private
private extension QuestionViewerViewModel {
    func makeIsSavedQuestion() -> Driver<Bool> {
        let initial = question
            .asObservable()
            .map { $0.isSaved }
        
        let isSavedQuestion = didTapMark
            .withLatestFrom(question) { ($0, $1.id) }
            .flatMapFirst { [weak self] isSaved, questionId -> Observable<Bool> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<Bool> {
                    let request = isSaved
                        ? self.questionManager.removeSavedQuestion(questionId: questionId)
                        : self.questionManager.saveQuestion(questionId: questionId)

                    return request
                        .map { !isSaved }
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
            }
        
        return Observable
            .merge(initial, isSavedQuestion)
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeElements() -> Driver<[TestingCellType]> {
        Driver
            .combineLatest(question, answeredIds, textSize)
            .map { [weak self] question, answeredIds, textSize -> [TestingCellType] in
                guard let self = self else {
                    return []
                }
                
                var result = [TestingCellType]()
                
                let questionCells = self.makeQuestionCells(question: question, textSize: textSize)
                result.append(contentsOf: questionCells)
                
                let answersCells = self.makeAnswersCells(question: question, answeredIds: answeredIds, textSize: textSize)
                result.append(contentsOf: answersCells)
                
                let explanationCells = self.makeExplanationCells(question: question)
                result.append(contentsOf: explanationCells)
                
                if let reference = question.reference, !reference.isEmpty {
                    result.append(.reference(reference))
                }
                
                return result
            }
    }
    
    func makeQuestionCells(question: Question, textSize: TextSize) -> [TestingCellType] {
        let content: [QuestionContentType] = [
            question.image.map { .image($0) },
            question.video.map { .video($0) }
        ].compactMap { $0 }
        
        return [
            !content.isEmpty ? .content(content) : nil,
            .question(question.question, html: question.questionHtml, textSize)
        ].compactMap { $0 }
    }
    
    func makeAnswersCells(question: Question, answeredIds: [Int], textSize: TextSize) -> [TestingCellType] {
        let result = question.answers.compactMap { answer -> AnswerResultElement in
            let state: AnswerState = answeredIds.contains(answer.id)
                    ? answer.isCorrect ? .correct : .error
                    : answer.isCorrect ? question.multiple ? .warning : .correct : .initial
            
            return AnswerResultElement(answer: answer.answer,
                                       answerHtml: answer.answerHtml,
                                       image: answer.image,
                                       state: state)
        }
        
        return [.result(result, textSize)]
    }
    
    func makeExplanationCells(question: Question) -> [TestingCellType] {
        let explanation: [TestingCellType]
    
        let explanationText: TestingCellType?
        if (question.explanation != nil || question.explanationHtml != nil) {
            explanationText = .explanationText(question.explanation ?? "", html: question.explanationHtml ?? "")
        } else {
            explanationText = nil
        }

        let explanationImages = question.media.map { TestingCellType.explanationImage($0)}

        if explanationText != nil || !explanationImages.isEmpty {
            explanation = [.explanationTitle] + explanationImages + [explanationText].compactMap { $0 }
        } else {
            explanation = []
        }
        
        return explanation
    }
    
    func makeScore() -> Driver<String> {
        let all = reviews
            .asDriver()
            .map { $0.count }
        
        let current = currentIndex.map { $0 + 1 }
        
        return Driver.combineLatest(current, all) {
            String(format: "%i/%i", $0, $1)
        }
    }
    
    func makeCurrentIndex() -> Driver<Int> {
        Driver
            .combineLatest(review, reviews.asDriver()) { review, reviews -> Int in
                let index = reviews.firstIndex(where: {
                    $0.question.id == review.question.id
                })
                
                return index ?? 0
            }
    }
    
    func makeTextSize() -> Driver<TextSize> {
        profileManager
            .obtainStudySettings()
            .map { $0.textSize }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeAnsweredIds() -> Driver<[Int]> {
        review
            .map { $0.userAnswersIds }
    }
    
    func makeQuestion() -> Driver<Question> {
        review
            .map { $0.question }
    }
    
    func makeReview() -> Driver<Review> {
        let initial = initialReview.asDriver()
        
        let action = Observable.merge(didTapPrevious.asObservable(), didTapNext.asObservable())
            .withLatestFrom(reviews) { ($0, $1) }
            .compactMap { index, reviews -> Review? in
                guard reviews.indices.contains(index) else {
                    return nil
                }
                
                return reviews[index]
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(initial, action)
    }
}
