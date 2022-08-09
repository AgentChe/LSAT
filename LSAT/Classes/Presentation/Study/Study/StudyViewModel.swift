//
//  StudyViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class StudyViewModel {
    lazy var sections = makeSections()
    lazy var activeSubscription = makeActiveSubscription()
    lazy var courseName = makeCourseName()
    
    lazy var activityIndicator = RxActivityIndicator()
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var course = makeCourse()
    
    private lazy var statsManager = StatsManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension StudyViewModel {
    func makeCourseName() -> Driver<String> {
        course
            .compactMap { $0?.name }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeSections() -> Driver<[StudyCollectionSection]> {
        let brief = makeBrief()
        let unlockQuestions = makeUnlockQuestions()
        let takeTest = makeTakeTest()
        let modesTitle = makeTitle(string: "Study.QuizModes".localized)
        let modes = makeModes()
        
        return Driver
            .combineLatest(brief, unlockQuestions, takeTest, modesTitle, modes) { brief, unlockQuestions, takeTest, modesTitle, modes -> [StudyCollectionSection] in
                var result = [StudyCollectionSection]()
                
                result.append(brief)
                if let unlockQuestions = unlockQuestions {
                    result.append(unlockQuestions)
                }
                result.append(takeTest)
                result.append(modesTitle)
                result.append(modes)
                
                return result
            }
    }
    
    func makeBrief() -> Driver<StudyCollectionSection> {
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
            .flatMap { [weak self] course -> Observable<(Course, Brief?)> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<(Course, Brief?)> {
                    self.statsManager
                        .obtainBrief(courseId: course.id)
                        .map { (course, $0) }
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
            .map { stub -> StudyCollectionSection in
                let (course, brief) = stub
                
                var calendar = [SCEBrief.Day]()
                
                for n in 0...6 {
                    let date = Calendar.current.date(byAdding: .day, value: -n, to: Date()) ?? Date()
                    
                    let briefCalendar = brief?.calendar ?? []
                    let activity = briefCalendar.indices.contains(n) ? briefCalendar[n] : false
    
                    let day = SCEBrief.Day(date: date, activity: activity)
    
                    calendar.append(day)
                }
                
                calendar.reverse()
                
                let entity = SCEBrief(courseName: course.name,
                                      streakDays: brief?.streak ?? 0,
                                      calendar: calendar)
                
                let element = StudyCollectionElement.brief(entity)
                return StudyCollectionSection(elements: [element])
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeUnlockQuestions() -> Driver<StudyCollectionSection?> {
        activeSubscription
            .map { activeSubscription -> StudyCollectionSection? in
                activeSubscription ? nil : StudyCollectionSection(elements: [.unlockAllQuestions])
            }
    }
    
    func makeTakeTest() -> Driver<StudyCollectionSection> {
        activeSubscription
            .map { activeSubscription -> StudyCollectionSection in
                StudyCollectionSection(elements: [.takeTest(activeSubscription: activeSubscription)])
            }
    }
    
    func makeTitle(string: String) -> Driver<StudyCollectionSection> {
        Driver<StudyCollectionSection>.deferred {
            let titleElement = StudyCollectionElement.title(string)
            let section = StudyCollectionSection(elements: [titleElement])
            
            return .just(section)
        }
    }
    
    func makeModes() -> Driver<StudyCollectionSection> {
        Driver<StudyCollectionSection>
            .deferred {
                let today = SCEMode(mode: .today,
                                    image: "Study.Mode.Todays",
                                    title: "Study.Mode.TodaysQuestion".localized)
                let todayElement = StudyCollectionElement.mode(today)
                
                let ten = SCEMode(mode: .ten,
                                    image: "Study.Mode.Ten",
                                    title: "Study.Mode.TenQuestions".localized)
                let tenElement = StudyCollectionElement.mode(ten)
                
                let missed = SCEMode(mode: .missed,
                                    image: "Study.Mode.Missed",
                                    title: "Study.Mode.MissedQuestions".localized)
                let missedElement = StudyCollectionElement.mode(missed)
                
                let saved = SCEMode(mode: .saved,
                                    image: "Study.Mode.Saved",
                                    title: "Study.Mode.Saved".localized)
                let savedElement = StudyCollectionElement.mode(saved)
                
                let timed = SCEMode(mode: .timed,
                                    image: "Study.Mode.Timed",
                                    title: "Study.Mode.Timed".localized)
                let timedElement = StudyCollectionElement.mode(timed)
                
                let random = SCEMode(mode: .random,
                                    image: "Study.Mode.Random",
                                    title: "Study.Mode.RandomSet".localized)
                let randomElement = StudyCollectionElement.mode(random)
                
                let section = StudyCollectionSection(elements: [
                    todayElement, tenElement, missedElement, savedElement, timedElement, randomElement
                ])
                
                return .just(section)
            }
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
    
    func makeActiveSubscription() -> Driver<Bool> {
        SDKStorage.shared
            .purchaseMediator
            .rxPurchaseMediatorDidValidateReceipt
            .map { $0?.activeSubscription ?? false }
            .asDriver(onErrorJustReturn: false)
            .startWith(SessionManager().getSession()?.activeSubscription ?? false)
    }
}
