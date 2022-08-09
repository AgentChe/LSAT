//
//  TestViewModel.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import RxSwift
import RxCocoa

final class TestViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    var activeSubscription = false
    
    let testType = BehaviorRelay<TestType?>(value: nil)
    let didTapMark = PublishRelay<Bool>()
    let didTapNext = PublishRelay<Void>()
    let didTapConfirm = PublishRelay<Void>()
    let didTapSubmit = PublishRelay<Void>()
    let didTapRestart = PublishRelay<Int>()
    let didTapNextQuestion = PublishRelay<Void>()
    let didTapPreviousQuestion = PublishRelay<Void>()
    let answers = BehaviorRelay<AnswerElement?>(value: nil)
    
    lazy var courseName = makeCourseName()
    lazy var vibration = makeVibration()
    lazy var isSavedQuestion = makeIsSavedQuestion()
    lazy var progress = makeProgress()
    lazy var score = makeScore()
    lazy var testFinishElement = makeTestFinishElement()
    lazy var questions = makeQuestions()
    lazy var question = makeQuestion()
    lazy var isEndOfTest = endOfTest()
    lazy var userTestId = makeUserTestId()
    lazy var bottomViewState = makeBottomState()
    lazy var testMode = makeTestMode()
    lazy var course = makeCourse()
    lazy var needPayment = makeNeedPayment()
    
    lazy var loadTestActivityIndicator = RxActivityIndicator()
    lazy var sendAnswerActivityIndicator = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private lazy var testElement = makeTest()
    private lazy var selectedAnswers = makeSelectedAnswers()
    private lazy var currentAnswers = makeCurrentAnswers()
    private lazy var studySettings = makeStudySettings()
    private lazy var timer = makeTimer()
    
    private lazy var questionManager = QuestionManager()
    private lazy var profileManager = ProfileManager()
    
    private let userAnsweredIsCorrect = PublishRelay<Bool>()
    private let answeredQuestionId = PublishRelay<Int>()
    private let savedQuestionRelay = PublishRelay<(Int, Bool)>()
}

// MARK: Private
private extension TestViewModel {
    func makeCourseName() -> Driver<String> {
        course
            .map { $0?.name ?? "" }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeVibration() -> Driver<Bool> {
        userAnsweredIsCorrect
            .withLatestFrom(studySettings) { ($0, $1) }
            .filter { $0.1.vibration }
            .map { $0.0 }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeIsSavedQuestion() -> Driver<Bool> {
        let initial = question
            .asObservable()
            .map { $0.isSaved }
        
        let isSavedQuestion = didTapMark
            .withLatestFrom(question) { ($0, $1) }
            .flatMapFirst { [weak self] isSaved, question -> Observable<Bool> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<Bool> {
                    let request = isSaved
                    ? self.questionManager.removeSavedQuestion(questionId: question.id)
                    : self.questionManager.saveQuestion(questionId: question.id)

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
                    .do(onNext: { isSaved in
                        self.savedQuestionRelay.accept((question.id, isSaved))
                    })
            }
        
        return Observable
            .merge(initial, isSavedQuestion)
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeProgress() -> Driver<String> {
        testType
            .flatMapLatest { [weak self] type -> Driver<String> in
                guard let self = self else {
                    return .just("")
                }
                
                let result: Driver<String>
                if case .timed = type {
                    result = self.timer
                        .map { $0.secondsToString() }
                        .asDriver(onErrorDriveWith: .never())
                } else {
                    result = self.question
                        .map { String(format: "Question.QuestionProgress".localized, $0.index, $0.questionsCount) }
                }
                
                return result
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeScore() -> Driver<Float> {
        question
            .map { questionElement -> Float in
                Float(questionElement.index) / Float(questionElement.questionsCount)
            }
    }
    
    func makeTestFinishElement() -> Driver<TestFinishElement> {
        let didFinishTest = timer
            .compactMap { $0 == 0 ? () : nil }
            .withLatestFrom(userTestId)
        
        let submit = didTapSubmit
            .withLatestFrom(userTestId)
        
        let userTestId = Observable
            .merge(didFinishTest, submit)
            .flatMapLatest { [weak self] userTestId -> Observable<Int> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Int> {
                    self.questionManager
                        .finishTest(userTestId: userTestId)
                        .map { userTestId }
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
                    .trackActivity(self.sendAnswerActivityIndicator)
            }
        
        return userTestId
            .withLatestFrom(courseName) { ($0, $1) }
            .withLatestFrom(testType) { ($0.0, $0.1, $1) }
            .compactMap { userTestId, courseName, testType -> TestFinishElement? in
                guard let testType = testType else {
                    return nil
                }
                
                return TestFinishElement(userTestId: userTestId,
                                         courseName: courseName,
                                         testType: testType)
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeQuestion() -> Driver<QuestionElement> {
        Observable<Action>
            .merge(
                self.didTapNext.debounce(.microseconds(500), scheduler: MainScheduler.instance).map { .continue },
                self.didTapNextQuestion.map { .next },
                self.didTapPreviousQuestion.map { .previous },
                self.questions.map { .elements($0) },
                self.didTapRestart.map { _ in .restart }
            )
            .scan((nil, []), accumulator: currentQuestionAccumulator)
            .compactMap { $0.0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQuestions() -> Observable<[QuestionElement]> {
        let questions = testElement
            .compactMap { $0.questions }
            .asObservable()
            .share(replay: 1)

        let mode = testMode.asObservable()
        let courseName = courseName.asObservable()
        let studySettings = studySettings.asObservable()
        
        return questions
            .flatMapLatest { [weak self] questions -> Observable<[QuestionElement]> in
                guard let self = self else {
                    return .never()
                }
                
                let elements = Observable
                    .combineLatest(self.selectedAnswers, mode, courseName, studySettings) {
                        QuestionAction.elements(questions, $0, $1, $2, $3)
                    }
                
                let answered = self.answeredQuestionId
                    .map { QuestionAction.answered(questionId: $0)}
                
                let saved = self.savedQuestionRelay
                    .map { QuestionAction.saved(questionId: $0, isSaved: $1) }
                
                return Observable
                    .merge(elements, answered, saved)
                    .scan([], accumulator: self.questionAccumulator)
            }
            .share(replay: 1)
    }
    
    func makeSelectedAnswers() -> Observable<AnswerElement?> {
        didTapConfirm
            .withLatestFrom(currentAnswers)
            .startWith(nil)
    }
    
    func makeTest() -> Driver<Test> {
        let load = loadTest().asDriver(onErrorDriveWith: .never())
        let restart = restartTest().asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(load, restart)
    }
    
    func loadTest() -> Observable<Test> {
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        let courseId = course
            .compactMap { $0?.id }
            .asObservable()
        let type = testType
            .compactMap { $0 }
            .asObservable()
        
        return Observable
            .combineLatest(courseId, type)
            .flatMapLatest { [weak self] courseId, type -> Observable<Test> in
                guard let self = self else {
                    return .empty()
                }
                
                let test: Single<Test?>
                
                switch type {
                case let .get(testId):
                    test = self.questionManager.obtain(courseId: courseId,
                                                       testId: testId,
                                                       time: nil,
                                                       activeSubscription: self.activeSubscription)
                case .tenSet:
                    test = self.questionManager.obtainTenSet(courseId: courseId,
                                                             activeSubscription: self.activeSubscription)
                case .failedSet:
                    test = self.questionManager.obtainFailedSet(courseId: courseId,
                                                                activeSubscription: self.activeSubscription)
                case .qotd:
                    test = self.questionManager.obtainQotd(courseId: courseId,
                                                           activeSubscription: self.activeSubscription)
                case .randomSet:
                    test = self.questionManager.obtainRandomSet(courseId: courseId,
                                                                activeSubscription: self.activeSubscription)
                case .saved:
                    test = self.questionManager.obtainSavedSet(courseId: courseId,
                                                               activeSubscription: self.activeSubscription)
                case .timed(let minutes):
                    test = self.questionManager.obtain(courseId: courseId,
                                                       testId: nil,
                                                       time: minutes,
                                                       activeSubscription: self.activeSubscription)
                }
                
                return test
                    .compactMap { $0 }
                    .asObservable()
                    .trackActivity(self.loadTestActivityIndicator)
                    .retry(when: { errorObs in
                        errorObs.flatMap { error in
                            trigger(error: error)
                        }
                    })
            }
    }
    
    func restartTest() -> Observable<Test> {
        didTapRestart
            .flatMapLatest { [weak self] userTestId -> Observable<Test> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<Test> {
                    self.questionManager
                        .obtainAgainTest(userTestId: userTestId)
                        .flatMap { test -> Single<Test> in
                            guard let test = test else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(test)
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
                    .trackActivity(self.loadTestActivityIndicator)
            }
    }
    
    func makeNeedPayment() -> Signal<Bool> {
        testElement
            .map { [weak self] element in
                guard let self = self else { return false }
                return self.activeSubscription ? false : element.paid ? true : false
            }
            .asSignal(onErrorSignalWith: .empty())
    }

    func makeUserTestId() -> Observable<Int> {
        testElement
            .compactMap { $0.userTestId }
            .asObservable()
    }
    
    func makeCurrentAnswers() -> Observable<AnswerElement?> {
        Observable
            .merge(answers.asObservable(),
                   didTapRestart.map { _ in nil },
                   didTapNext.map { nil },
                   didTapNextQuestion.map { nil },
                   didTapPreviousQuestion.map { nil }
            )
    }
    
    func endOfTest() -> Observable<Bool> {
        selectedAnswers
            .compactMap { $0 }
            .withLatestFrom(testElement) {
                ($0, $1.userTestId)
            }
            .flatMapLatest { [weak self] element, userTestId -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Bool?> {
                    self.questionManager
                        .sendAnswer(
                            questionId: element.questionId,
                            userTestId: userTestId,
                            answerIds: element.answerIds
                        )
                        .do(onSuccess: { [weak self] _ in
                            self?.answeredQuestionId.accept(element.questionId)
                        })
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
                    .trackActivity(self.sendAnswerActivityIndicator)
                    .compactMap { $0 }
                    .asObservable()
            }
            .catchAndReturn(false)
    }
    
    func makeBottomState() -> Driver<BottomView.State> {
        Driver
            .combineLatest(
                question,
                currentAnswers.asDriver(onErrorJustReturn: nil),
                testMode
            )
            .map { question, answers, testMode -> BottomView.State in
                
                if question.elements.contains(where: { $0.isResult }) {
                    if question.isLast {
                        return question.questionsCount == 1 ? .back : .submit
                    } else {
                        return testMode == .onAnExam ? .hidden : .next
                    }
                } else {
                    return answers?.answerIds.isEmpty == false ? .confirm : .hidden
                }
            }
            .startWith(.hidden)
            .distinctUntilChanged()
    }
    
    func makeTestMode() -> Driver<TestMode?> {
        profileManager
            .obtainTestMode(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
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
    
    func makeStudySettings() -> Driver<StudySettings> {
        profileManager
            .obtainStudySettings()
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeTimer() -> Observable<Int> {
        testElement
            .asObservable()
            .withLatestFrom(testType)
            .flatMapLatest { testType -> Observable<Int> in
                guard case let .timed(minutes) = testType else {
                    return .empty()
                }
                
                let startTime = CFAbsoluteTimeGetCurrent()
                let seconds = minutes * 60
                
                return Observable<Int>
                    .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
                    .map { _ in Int(CFAbsoluteTimeGetCurrent() - startTime) }
                    .take(until: { $0 >= seconds }, behavior: .inclusive)
                    .map { max(0, seconds - $0) }
                    .distinctUntilChanged()
            }
    }
}

// MARK: Additional
private extension TestViewModel {
    enum Action {
        case next
        case previous
        case `continue`
        case elements([QuestionElement])
        case restart
    }
    
    enum QuestionAction {
        case elements([Question], AnswerElement?, TestMode?, String, StudySettings)
        case answered(questionId: Int)
        case saved(questionId: Int, isSaved: Bool)
    }
    
    var questionAccumulator: ([QuestionElement], QuestionAction) -> [QuestionElement] {
        return { [weak self] old, action in
            switch action {
            case let .elements(questions, answers, testMode, courseName, studySettings):
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
                            !content.isEmpty ? .content(content) : nil,
                            .question(question.question, html: question.questionHtml, studySettings.textSize),
                            .answers(answers, studySettings.textSize)
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
                            questionsCount: questions.count,
                            isSaved: question.isSaved
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
                        self?.userAnsweredIsCorrect.accept(isCorrect)
                        self?.logAnswerAnalitycs(isCorrect: isCorrect, courseName: courseName)
                    } else {
                        let isCorrect = !result.contains(where: { $0.state == .error })
                        self?.userAnsweredIsCorrect.accept(isCorrect)
                        self?.logAnswerAnalitycs(isCorrect: isCorrect, courseName: courseName)
                    }
                    
                    return .result(result, studySettings.textSize)
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
                    questionsCount: currentElement.questionsCount,
                    isSaved: currentElement.isSaved
                )
                var result = old
                result[index] = newElement
                return result
            case let .answered(questionId):
                guard let index = old.firstIndex(where: { $0.id == questionId }) else {
                    return old
                }
                
                var currentElement = old[index]
                currentElement.isAnswered = true
                var result = old
                result[index] = currentElement
                return result
            case let .saved(questionId, isSaved):
                guard let index = old.firstIndex(where: { $0.id == questionId }) else {
                    return old
                }
                
                var currentElement = old[index]
                currentElement.isSaved = isSaved
                var result = old
                result[index] = currentElement
                return result
            }
        }
    }
    
    var currentQuestionAccumulator: ((QuestionElement?, [QuestionElement]), Action) -> (QuestionElement?, [QuestionElement]) {
        return { old, action -> (QuestionElement?, [QuestionElement]) in
            let (currentElement, elements) = old
            
            switch action {
            case let .elements(questions):
                // Проверка для вопроса дня, чтобы была возможность отобразить вопрос,
                // если юзер уже на него отвечал
                guard questions.count > 1 else { return (questions.first, questions) }
                
                // Флаг isAnswered проставлен в true либо бэком либо локально,
                // при успешной отправке ответа, в этом случае игнорм всю логику
                // и возвращаем предыдущее значение, переключение на следцющий вопрос
                // вызовет другой кейс
                if let current = questions.first(where: { $0.id == currentElement?.id }), current.isAnswered {
                    return (current, questions)
                } else {
                    let withoutAnswered = questions.filter { !$0.isAnswered }
                    let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }) ?? 0
                    return (withoutAnswered[safe: index], questions)
                }
            case .next:
                let index = elements.firstIndex(where: { $0.id == currentElement?.id }).map { $0 + 1 } ?? 0
                return (elements[safe: index] ?? currentElement, elements)
            case .previous:
                let index = elements.firstIndex(where: { $0.id == currentElement?.id }).map { $0 - 1 } ?? 0
                return (elements[safe: index] ?? currentElement, elements)
            case .continue:
                let currentIndex = elements.firstIndex(where: { $0.id == currentElement?.id }) ?? 0
                let withoutAnswered = elements.suffix(from: currentIndex).filter { !$0.isAnswered }
                
                // Для случая, когда пользователь ответил на последний вопрос и вернулся обратно. Тогда, массив withoutAnswered будет пустым и ведем пользователя по порядку
                let array = withoutAnswered.isEmpty ? elements : withoutAnswered
                
                let index = array.firstIndex(where: { $0.id == currentElement?.id }).map { $0 + 1 } ?? 0
                return (array[safe: index] ?? currentElement, elements)
            case .restart:
                return (nil, elements)
            }
        }
    }
}

private extension TestViewModel {
    func logAnswerAnalitycs(isCorrect: Bool, courseName: String) {
        guard let type = testType.value else {
            return
        }
        let name = isCorrect ? "Question Answered Correctly" : "Question Answered Incorrectly"
        let mode = TestAnalytics.name(mode: type)
        
        SDKStorage.shared.amplitudeManager
            .logEvent(name: name, parameters: ["course" : courseName, "mode": mode])
    }
}

private extension Int {
    func secondsToString() -> String {
        let seconds = self
        var mins = 0
        var secs = seconds
        if seconds >= 60 {
            mins = Int(seconds / 60)
            secs = seconds - (mins * 60)
        }
        
        return String(format: "%02d:%02d", mins, secs)
    }
}

private extension TestingCellType {
    var isResult: Bool {
        if case .result = self {
            return true
        } else {
            return false
        }
    }
}

private extension QuestionElement {
    var isLast: Bool { index == questionsCount }
}
