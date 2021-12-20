//
//  CoursesManagerCore.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift

final class CoursesManagerCore: CoursesManager {
    enum Constants {
        static let selectedCourseCacheKey = "courses_manager_core_selected_course_cache_key"
        static let cachedReferencesKey = "courses_manager_core_cached_references_key"
    }
}

// MARK: API
extension CoursesManagerCore {
    func getSelectedCourse() -> Course? {
        guard let data = UserDefaults.standard.data(forKey: Constants.selectedCourseCacheKey) else {
            return nil
        }

        return try? JSONDecoder().decode(Course.self, from: data)
    }
}

// MARK: API(Rx)
extension CoursesManagerCore {
    func retrieveCourses() -> Single<[Course]> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just([]) }
        }
        
        let request = GetCourcesRequest(userToken: userToken)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetCourcesResponseMapper.map(from:))
    }
    
    func rxSelect(course: Course) -> Single<Void> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SetSelectCourseRequest(userToken: userToken, courseId: course.id)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map { _ in Void() }
            .do(onSuccess: {
                guard let data = try? JSONEncoder().encode(course) else {
                    return
                }
        
                UserDefaults.standard.set(data, forKey: Constants.selectedCourseCacheKey)
            })
    }
    
    func retrieveSelectedCourse(forceUpdate: Bool = false) -> Single<Course?> {
        guard forceUpdate else {
            return .deferred { [weak self] in
                guard let self = self else {
                    return .never()
                }
                
                let course = self.getSelectedCourse()
                
                return .just(course)
            }
        }
        
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetSelectedCourseRequest(userToken: userToken)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map { GetSelectedCourseResponse.map(from: $0) }
            .do(onSuccess: { course in
                guard let data = try? JSONEncoder().encode(course) else {
                    return
                }

                UserDefaults.standard.set(data, forKey: Constants.selectedCourseCacheKey)
            })
    }
}

// MARK: References
extension CoursesManagerCore {
    func retrieveReferences(forceUpdate: Bool) -> Single<[Reference]> {
        guard forceUpdate else {
            return getCachedReferenced()
        }
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: GetReferencesRequest())
            .map(GetReferencesResponseMapper.map(from:))
            .flatMap { [weak self] references -> Single<[Reference]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.write(references: references)
            }
    }
    
    private func write(references: [Reference]) -> Single<[Reference]> {
        Single<[Reference]>
            .create { event in
                guard let data = try? JSONEncoder().encode(references) else {
                    event(.success(references))
                    return Disposables.create()
                }
                
                UserDefaults.standard.setValue(data, forKey: Constants.cachedReferencesKey)
                
                event(.success(references))
                
                return Disposables.create()
            }
    }
    
    private func getCachedReferenced() -> Single<[Reference]> {
        Single<[Reference]>
            .create { event in
                guard
                    let data = UserDefaults.standard.data(forKey: Constants.cachedReferencesKey),
                    let references = try? JSONDecoder().decode([Reference].self, from: data)
                else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                event(.success(references))
                
                return Disposables.create()
            }
    }
}
