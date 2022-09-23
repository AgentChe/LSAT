//
//  QuestionManagerCore.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import RxSwift
import OtterScaleiOS

protocol QuestionManagerProtocol: AnyObject {
    func obtain(courseId: Int, testId: Int?, time: Int?, activeSubscription: Bool) -> Single<Test?>
    func obtainTenSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainFailedSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainQotd(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainRandomSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainSavedSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func obtainOnboardingSet(forceUpdate: Bool) -> Single<Test?>
    func obtainAgainTest(userTestId: Int) -> Single<Test?>
    func obtainReview(courseId: Int, mode: Int, offset: Int) -> Single<[Review]>
    func finishTest(userTestId: Int) -> Single<Void>
    func sendAnswer(questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?>
    func saveQuestion(questionId: Int) -> Single<Void>
    func removeSavedQuestion(questionId: Int) -> Single<Void>
    func retrieveConfig(courseId: Int) -> Single<[TestConfig]>
    func report(questionId: Int, reason: Int, email: String?, comment: String) -> Single<Void>
}

final class QuestionManager: QuestionManagerProtocol {
    enum Constants {
        static let onboardingSetKey = "question_manager_onboarding_set_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private let xorRequestWrapper = XORRequestWrapper()
    private let defaultRequestWrapper = DefaultRequestWrapper()
}

// MARK: Public
extension QuestionManager {
    func obtain(courseId: Int, testId: Int?, time: Int?, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetTestRequest(
            userToken: userToken,
            courseId: courseId,
            testid: testId,
            time: time,
            activeSubscription: activeSubscription
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func obtainTenSet(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetTenSetRequest(userToken: userToken,
                                       courseId: courseId,
                                       activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func obtainFailedSet(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetFailedSetRequest(userToken: userToken,
                                          courseId: courseId,
                                          activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func obtainQotd(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetQotdRequest(userToken: userToken,
                                     courseId: courseId,
                                     activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func obtainRandomSet(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetRandomSetRequest(userToken: userToken,
                                          courseId: courseId,
                                          activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func obtainSavedSet(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetSavedSetRequest(userToken: userToken,
                                         courseId: courseId,
                                         activeSubscription: activeSubscription)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: false) }
    }
    
    func obtainOnboardingSet(forceUpdate: Bool) -> Single<Test?> {
        forceUpdate ? loadOnboardingSet() : cachedOnboardingSet()
    }
    
    func obtainAgainTest(userTestId: Int) -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = AgainTestRequest(userToken: userToken,
                                       userTestId: userTestId)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try GetTestResponseMapper.map(from: $0, isEncryption: true) }
    }
    
    func obtainReview(courseId: Int, mode: Int, offset: Int) -> Single<[Review]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetReviewRequest(userToken: userToken,
                                       courseId: courseId,
                                       mode: mode,
                                       offset: offset)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { GetReviewResponse.map(from: $0) }
    }
    
    func finishTest(userTestId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = FinishTestRequest(userToken: userToken,
                                        userTestId: userTestId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func sendAnswer(questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = SendAnswerRequest(
            userToken: userToken,
            questionId: questionId,
            userTestId: userTestId,
            answerIds: answerIds
        )
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try SendAnswerResponseMapper.map(from: $0) }
            .do(onSuccess: { isEndOfTest in
                if isEndOfTest == true {
                    QuestionMediator.shared.notidyAboutTestPassed()
                }
            })
    }
    
    func saveQuestion(questionId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SaveQuestionRequest(userToken: userToken,
                                          questionId: questionId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func removeSavedQuestion(questionId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = RemoveSavedQuestionRequest(userToken: userToken,
                                                 questionId: questionId)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func retrieveConfig(courseId: Int) -> Single<[TestConfig]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetTestConfigRequest(userToken: userToken,
                                               courseId: courseId)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { GetTestConfigResponseMapper.from(response: $0) }
    }
    
    func report(questionId: Int, reason: Int, email: String?, comment: String) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = ReportRequest(userToken: userToken,
                                    questionId: questionId,
                                    userId: OtterScale.shared.getUserID(),
                                    reason: reason,
                                    email: email,
                                    comment: comment)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
}

// MARK: Private
private extension QuestionManager {
    func loadOnboardingSet() -> Single<Test?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetOnboardingSetRequest(userToken: userToken)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try? GetTestResponseMapper.map(from: $0, isEncryption: true) }
            .do(onSuccess: { test in
                guard let test = test, let data = try? JSONEncoder().encode(test) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.onboardingSetKey)
            })
    }
    
    func cachedOnboardingSet() -> Single<Test?> {
        Single<Test?>
            .create { event in
                guard
                    let data = UserDefaults.standard.data(forKey: Constants.onboardingSetKey),
                    let test = try? JSONDecoder().decode(Test.self, from: data)
                else {
                    event(.success(nil))
                    return Disposables.create()
                }
                
                event(.success(test))
                
                return Disposables.create()
            }
    }
}
