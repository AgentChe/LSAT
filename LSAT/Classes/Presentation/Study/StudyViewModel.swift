//
//  StudyViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class StudyViewModel {
    private lazy var courseManager = CoursesManagerCore()
    private lazy var sessionManager = SessionManagerCore()
    private lazy var questionManager = QuestionManagerCore()
    private lazy var statsManager = StatsManagerCore()
    
    lazy var sections = makeSections()
    lazy var activeSubscription = makeActiveSubscription()
    lazy var courseName = makeCourseName()
}

// MARK: Private
private extension StudyViewModel {
    func makeCourseName() -> Driver<String> {
        courseManager
            .retrieveSelectedCourse()
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
        QuestionManagerMediator.shared.rxTestPassed
            .asObservable()
            .startWith(())
            .flatMap { [weak self] _ -> Single<(Course, Brief?)> in
                guard let this = self, let course = self?.courseManager.getSelectedCourse() else {
                    return .never()
                }
                
                return this.statsManager
                    .retrieveBrief(courseId: course.id)
                    .map { (course, $0) }
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
                
                let random = SCEMode(mode: .random,
                                    image: "Study.Mode.Random",
                                    title: "Study.Mode.RandomSet".localized)
                let randomElement = StudyCollectionElement.mode(random)
                
                let section = StudyCollectionSection(elements: [
                    todayElement, tenElement, missedElement, randomElement
                ])
                
                return .just(section)
            }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        let updated = SDKStorage.shared
            .purchaseMediator
            .rxPurchaseMediatorDidValidateReceipt
            .compactMap { $0?.activeSubscription }
            .asDriver(onErrorJustReturn: false)
        
        let initial = Driver<Bool>
            .deferred { [weak self] in
                guard let this = self else {
                    return .never()
                }
                
                let activeSubscription = this.sessionManager.getSession()?.activeSubscription ?? false
                
                return .just(activeSubscription)
            }
        
        return Driver
            .merge(initial, updated)
    }
}
