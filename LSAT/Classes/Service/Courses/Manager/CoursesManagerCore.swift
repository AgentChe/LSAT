//
//  CoursesManagerCore.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import SnapKit
import Darwin

final class CoursesManagerCore: CoursesManager {
    enum Constants {
        static let selectedCourseCacheKey = "courses_manager_core_selected_course_cache_key"
        static let cachedReferencesKey = "courses_manager_core_cached_references_key"
        static let coursesKey = "courses_manager_core_cached_courses_key"
    }
    
    private let defaultRequestWrapper = DefaultRequestWrapper()
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
    func retrieveCourses(forceUpdate: Bool) -> Single<[Course]> {
        forceUpdate ? downloadAndCacheCourses() : cachedCourses()
    }
    
    func rxSelect(course: Course) -> Single<Void> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SetSelectCourseRequest(userToken: userToken, courseId: course.id)
        
        return defaultRequestWrapper
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
        
        let extractedExpr = GetSelectedCourseRequest(userToken: userToken)
        let request = extractedExpr
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try GetSelectedCourseResponse.map(from: $0) }
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
    // С 42 (Nursing) билда всегда пустой массив
    func retrieveReferences(forceUpdate: Bool) -> Single<[Reference]> {
        .deferred { .just([]) }
//        guard forceUpdate else {
//            return getCachedReferenced()
//        }
//
//        return defaultRequestWrapper
//            .callServerApi(requestBody: GetReferencesRequest())
//            .map(GetReferencesResponseMapper.map(from:))
//            .flatMap { [weak self] references -> Single<[Reference]> in
//                guard let self = self else {
//                    return .never()
//                }
//
//                return self.write(references: references)
//            }
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

// MARK: Private
private extension CoursesManagerCore {
    func downloadAndCacheCourses() -> Single<[Course]> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetCourcesRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { try GetCourcesResponseMapper.map(from: $0) }
            .do(onSuccess: { courses in
                guard let data = try? JSONEncoder().encode(courses) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.coursesKey)
            })
    }
    
    func cachedCourses() -> Single<[Course]> {
        Single<[Course]>
            .create { event in
                guard
                    let data = UserDefaults.standard.data(forKey: Constants.coursesKey),
                    let courses = try? JSONDecoder().decode([Course].self, from: data)
                else {
                    event(.success([]))
                    return Disposables.create()
                }
                
                event(.success(courses))
                
                return Disposables.create()
            }
    }
}
