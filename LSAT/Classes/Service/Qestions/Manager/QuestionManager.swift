//
//  QuestionManager.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import RxSwift

protocol QuestionManager: AnyObject {
    // MARK: API(Rx)
    func retrieve(courseId: Int, testId: Int?, activeSubscription: Bool) -> Single<Test?>
    func retrieveTenSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func retrieveFailedSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func retrieveQotd(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func retrieveRandomSet(courseId: Int, activeSubscription: Bool) -> Single<Test?>
    func retrieveOnboardingSet(forceUpdate: Bool) -> Single<Test?>
    func sendAnswer(questionId: Int, userTestId: Int, answerIds: [Int]) -> Single<Bool?>
    func retrieveConfig(courseId: Int) -> Single<[TestConfig]>
}
