//
//  QuestionManagerCore.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import RxSwift

final class QuestionManagerCore: QuestionManager {
    enum Constants {
        static let onboardingSetKey = "question_manager_core_onboarding_set_key"
    }
    
    private let xorRequestWrapper = XORRequestWrapper()
    private let defaultRequestWrapper = DefaultRequestWrapper()
}

// MARK: Public
extension QuestionManagerCore {
    func retrieve(courseId: Int, testId: Int?, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetTestRequest(
            userToken: userToken,
            courseId: courseId,
            testid: testId,
            activeSubscription: activeSubscription
        )
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map(GetTestResponseMapper.map(from:))
    }
    
    func retrieveTenSet(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetTenSetRequest(userToken: userToken,
                                       courseId: courseId,
                                       activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map(GetTestResponseMapper.map(from:))
    }
    
    func retrieveFailedSet(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetFailedSetRequest(userToken: userToken,
                                          courseId: courseId,
                                          activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map(GetTestResponseMapper.map(from:))
    }
    
    func retrieveQotd(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetQotdRequest(userToken: userToken,
                                     courseId: courseId,
                                     activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map(GetTestResponseMapper.map(from:))
    }
    
    func retrieveRandomSet(courseId: Int, activeSubscription: Bool) -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just(nil) }
        }
        
        let request = GetRandomSetRequest(userToken: userToken,
                                          courseId: courseId,
                                          activeSubscription: activeSubscription)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map(GetTestResponseMapper.map(from:))
    }
    
    func retrieveOnboardingSet(forceUpdate: Bool) -> Single<Test?> {
        forceUpdate ? downloadAndCacheOnboardingSet() : cachedOnboardingSet()
    }
    
    func sendAnswer(questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
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
            .map(SendAnswerResponseMapper.map(from:))
            .do(onSuccess: { isEndOfTest in
                if isEndOfTest == true {
                    QuestionManagerMediator.shared.testPassed()
                }
            })

    }
    
    func retrieveConfig(courseId: Int) -> Single<[TestConfig]> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetTestConfigRequest(userToken: userToken,
                                               courseId: courseId)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map(GetTestConfigResponseMapper.from(response:))
    }
}

// MARK: Private
private extension QuestionManagerCore {
    func downloadAndCacheOnboardingSet() -> Single<Test?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetOnboardingSetRequest(userToken: userToken)
        
        return xorRequestWrapper
            .callServerStringApi(requestBody: request)
            .map { try? GetTestResponseMapper.map(from: $0) }
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
