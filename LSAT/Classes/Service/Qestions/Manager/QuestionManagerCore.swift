//
//  QuestionManagerCore.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import RxSwift

final class QuestionManagerCore: QuestionManager {}

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
        
        return SDKStorage.shared
            .restApiTransport
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
        
        return SDKStorage.shared
            .restApiTransport
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
        
        return SDKStorage.shared
            .restApiTransport
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
        
        return SDKStorage.shared
            .restApiTransport
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
        
        return SDKStorage.shared
            .restApiTransport
            .callServerStringApi(requestBody: request)
            .map(GetTestResponseMapper.map(from:))
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
        
        return SDKStorage.shared
            .restApiTransport
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
        
        return SDKStorage.shared
            .restApiTransport
            .callServerStringApi(requestBody: request)
            .map(GetTestConfigResponseMapper.from(response:))
    }
}
