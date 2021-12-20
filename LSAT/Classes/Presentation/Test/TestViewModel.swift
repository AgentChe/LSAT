//
//  TestViewModel.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import RxSwift
import RxCocoa

final class TestViewModel {
    
    var activeSubscription = false
    
    let testType = BehaviorRelay<TestType?>(value: nil)
    let didTapNext = PublishRelay<Void>()
    let didTapConfirm = PublishRelay<Void>()
    let didTapSubmit = PublishRelay<Void>()
    let answers = BehaviorRelay<AnswerElement?>(value: nil)
    
    lazy var courseName = makeCourseName()
    lazy var question = makeQuestion()
    lazy var isEndOfTest = endOfTest()
    lazy var userTestId = makeUserTestId()
    lazy var bottomViewState = makeBottomState()
    lazy var testMode = makeTestMode()
    lazy var errorMessage = makeErrorMessage()
    lazy var needPayment = makeNeedPayment()
    
    private lazy var questionManager = QuestionManagerCore()
    private lazy var courseManager = CoursesManagerCore()
    private lazy var profileManager = ProfileManagerCore()
    
    private lazy var testElement = loadTest().share(replay: 1, scope: .forever)
    private lazy var selectedAnswers = makeSelectedAnswers().share(replay: 1, scope: .forever)
    private lazy var currentAnswers = makeCurrentAnswers().share(replay: 1, scope: .forever)
}

// MARK: Private
private extension TestViewModel {
    func makeCourseName() -> Driver<String> {
        courseManager
            .retrieveSelectedCourse()
            .compactMap { $0?.name }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQuestion() -> Driver<QuestionElement> {
        Observable<Action>
            .merge(
                didTapNext.debounce(.microseconds(500), scheduler: MainScheduler.instance).map { _ in .next },
                makeQestions().map { .elements($0) }
            )
            .scan((nil, []), accumulator: currentQuestionAccumulator)
            .compactMap { $0.0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQestions() -> Observable<[QuestionElement]> {
        let questions = testElement
            .compactMap { $0.element?.questions }
        
        let dataSource = Observable
            .combineLatest(questions, selectedAnswers)
            .withLatestFrom(testMode) { ($0.0, $0.1, $1) }
            .scan([], accumulator: questionAccumulator)
        
        return dataSource
    }
    
    func makeSelectedAnswers() -> Observable<AnswerElement?> {
        didTapConfirm
            .withLatestFrom(currentAnswers)
            .startWith(nil)
    }
    
    func loadTest() -> Observable<Event<Test>> {
        guard let courseId = courseManager.getSelectedCourse()?.id else {
            return .empty()
        }
        
        return testType
            .compactMap { $0 }
            .flatMapLatest { [weak self] type -> Observable<Event<Test>> in
                guard let self = self else { return .empty() }
                
                let test: Single<Test?>
                
                switch type {
                case let .get(testId):
                    test = self.questionManager.retrieve(courseId: courseId,
                                                         testId: testId,
                                                         activeSubscription: self.activeSubscription)
                case .tenSet:
                    test = self.questionManager.retrieveTenSet(courseId: courseId,
                                                               activeSubscription: self.activeSubscription)
                case .failedSet:
                    test = self.questionManager.retrieveFailedSet(courseId: courseId,
                                                                  activeSubscription: self.activeSubscription)
                case .qotd:
                    test = self.questionManager.retrieveQotd(courseId: courseId,
                                                             activeSubscription: self.activeSubscription)
                case .randomSet:
                    test = self.questionManager.retrieveRandomSet(courseId: courseId,
                                                                  activeSubscription: self.activeSubscription)
                }
                
                return test
                    .compactMap { $0 }
                    .asObservable()
                    .materialize()
                    .filter {
                        guard case .completed = $0 else { return true }
                        return false
                    }
            }
    }
    
    func makeErrorMessage() -> Signal<String> {
        testElement
            .compactMap { $0.error?.localizedDescription }
            .asSignal(onErrorSignalWith: .empty())
    }
    
    func makeNeedPayment() -> Signal<Bool> {
        testElement
            .map { [weak self] event in
                guard let self = self, let element = event.element else { return false }
                return self.activeSubscription ? false : element.paid ? true : false
            }
            .asSignal(onErrorSignalWith: .empty())
    }

    func makeUserTestId() -> Observable<Int> {
        didTapSubmit
            .withLatestFrom(testElement)
            .compactMap { $0.element?.userTestId }
    }
    
    func makeCurrentAnswers() -> Observable<AnswerElement?> {
        Observable.merge(answers.asObservable(), didTapNext.map { _ in nil })
    }
    
    func endOfTest() -> Driver<Bool> {
        selectedAnswers
            .compactMap { $0 }
            .withLatestFrom(testElement) {
                ($0, $1.element?.userTestId)
                
            }
            .flatMapLatest { [questionManager] element, userTestId -> Observable<Bool> in
                guard let userTestId = userTestId else { return .just(false) }
                
                return questionManager
                    .sendAnswer(
                        questionId: element.questionId,
                        userTestId: userTestId,
                        answerIds: element.answerIds
                    )
                    .catchAndReturn(nil)
                    .compactMap { $0 }
                    .asObservable()
            }
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeBottomState() -> Driver<TestBottomButtonState> {
        Driver.combineLatest(isEndOfTest, question, currentAnswers.asDriver(onErrorJustReturn: nil))
            .map { isEndOfTest, question, answers -> TestBottomButtonState in
                let isResult = question.elements.contains(where: {
                    guard case .result = $0 else { return false }
                    return true
                })
                
                if question.index == question.questionsCount, question.questionsCount != 1, isResult {
                    return isEndOfTest ? .submit : .hidden
                } else {
                    guard isResult && question.questionsCount == 1 else {
                        return isResult ? .hidden : answers?.answerIds.isEmpty == false ? .confirm : .hidden
                    }
                    
                    return .back
                }
            }
            .startWith(.hidden)
            .distinctUntilChanged()
    }
    
    func makeTestMode() -> Driver<TestMode?> {
        profileManager
            .obtainTestMode()
            .asDriver(onErrorJustReturn: nil)
    }
}

// MARK: Additional
private extension TestViewModel {
    enum Action {
        case next
        case previos
        case elements([QuestionElement])
    }
    
    var questionAccumulator: ([QuestionElement], ([Question], AnswerElement?, TestMode?)) -> [QuestionElement] {
        return { [weak self] (old, args) -> [QuestionElement] in
            let (questions, answers, testMode) = args
            guard !old.isEmpty else {
                return questions.enumerated().map { index, question in
                    let answers = question.answers.map { PossibleAnswerElement(id: $0.id,
                                                                               answer: $0.answer,
                                                                               answerHtml: $0.answerHtml,
                                                                               image: $0.image) }
                    
                    let content: [QuestionContentType] = [
                        question.image.map { .image($0) },
                        question.video.map { .video($0) }
                    ].compactMap { $0 }
                    
                    let elements: [TestingCellType] = [
                        questions.count > 1 ? .questionsProgress(String(format: "Question.QuestionProgress".localized, index + 1, questions.count)) : nil,
                        !content.isEmpty ? .content(content) : nil,
                        .question(question.question, html: question.questionHtml),
                        .answers(answers)
                    ].compactMap { $0 }
                    
                    var referenceCellType = [TestingCellType]()
                    if let reference = question.reference, !reference.isEmpty {
                        referenceCellType.append(.reference(reference))
                    }
                    
                    return QuestionElement(
                        id: question.id,
                        elements: elements + referenceCellType,
                        isMultiple: question.multiple,
                        index: index + 1,
                        isAnswered: question.isAnswered,
                        questionsCount: questions.count
                    )
                }
            }
            
            guard let currentAnswers = answers, let currentQuestion = questions.first(where: { $0.id == currentAnswers.questionId }) else {
                return old
            }
            
            let currentMode = questions.count > 1 ? testMode : .fullComplect
            
            guard let index = old.firstIndex(where: { $0.id == currentAnswers.questionId }) else {
                return old
            }
            let currentElement = old[index]
            let newElements = currentElement.elements.compactMap { value -> TestingCellType? in
                if case .reference = value { return nil }
                
                guard case .answers = value else { return value }
                
                let result = currentQuestion.answers.map { answer -> AnswerResultElement in
                    let state: AnswerState
                    
                    if currentMode == .onAnExam {
                        state = .initial
                    } else {
                        state = currentAnswers.answerIds.contains(answer.id)
                            ? answer.isCorrect ? .correct : .error
                            : answer.isCorrect ? currentQuestion.multiple ? .warning : .correct : .initial
                    }
                    
                    return AnswerResultElement(answer: answer.answer,
                                               answerHtml: answer.answerHtml,
                                               image: answer.image,
                                               state: state)
                }
                
                if currentQuestion.multiple {
                    let isCorrect = !result.contains(where: { $0.state == .warning || $0.state == .error })
                    self?.logAnswerAnalitycs(isCorrect: isCorrect)
                } else {
                    let isCorrect = result.contains(where: { $0.state == .correct })
                    self?.logAnswerAnalitycs(isCorrect: isCorrect)
                }
                
                return .result(result)
            }
            
            let explanation: [TestingCellType]
            
            if [.none, .fullComplect].contains(testMode) {
                let explanationText: TestingCellType?
                if (currentQuestion.explanation != nil || currentQuestion.explanationHtml != nil) {
                    explanationText = .explanationText(currentQuestion.explanation ?? "", html: currentQuestion.explanationHtml ?? "")
                } else {
                    explanationText = nil
                }
                
                let explanationImages = currentQuestion.media.map { TestingCellType.explanationImage($0)}
                
                if explanationText != nil || !explanationImages.isEmpty {
                    explanation = [.explanationTitle] + explanationImages + [explanationText].compactMap { $0 }
                } else {
                    explanation = []
                }
                
            } else {
                explanation = []
            }
            
            var referenceCellType = [TestingCellType]()
            if let reference = currentQuestion.reference, !reference.isEmpty {
                referenceCellType.append(.reference(reference))
            }
            
            let newElement = QuestionElement(
                id: currentElement.id,
                elements: newElements + explanation + referenceCellType,
                isMultiple: currentElement.isMultiple,
                index: currentElement.index,
                isAnswered: currentElement.isAnswered,
                questionsCount: currentElement.questionsCount
            )
            var result = old
            result[index] = newElement
            return result
        }
    }
    
    var currentQuestionAccumulator: ((QuestionElement?, [QuestionElement]), Action) -> (QuestionElement?, [QuestionElement]) {
        return { old, action -> (QuestionElement?, [QuestionElement]) in
            let (currentElement, elements) = old
            let withoutAnswered = elements.filter { !$0.isAnswered }
            switch action {
            case let .elements(questions):
                // Проверка для вопроса дня, чтобы была возможность отобразить вопрос,
                // если юзер уже на него отвечал
                guard questions.count > 1 else { return (questions.first, questions) }
                
                let withoutAnswered = questions.filter { !$0.isAnswered }
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }) ?? 0
                return (withoutAnswered[safe: index], questions)
            case .next:
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }).map { $0 + 1 } ?? 0
                return (withoutAnswered[safe: index] ?? currentElement, elements)
            case .previos:
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }).map { $0 - 1 } ?? 0
                return (withoutAnswered[safe: index] ?? currentElement, elements)
            }
        }
    }
}

private extension TestViewModel {
    
    func logAnswerAnalitycs(isCorrect: Bool) {
        guard let type = testType.value, let courseName = courseManager.getSelectedCourse()?.name else {
            return
        }
        let name = isCorrect ? "Question Answered Correctly" : "Question Answered Incorrectly"
        let mode = TestAnalytics.name(mode: type)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: name, parameters: ["course" : courseName, "mode": mode])
    }
}
