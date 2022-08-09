//
//  CoursesManagerCore.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import SnapKit
import Darwin

protocol CoursesManagerProtocol: AnyObject {
    func retrieveCourses(forceUpdate: Bool) -> Single<[Course]>
    func retrieveReferences(forceUpdate: Bool) -> Single<[Reference]>
}

final class CoursesManager: CoursesManagerProtocol {
    enum Constants {
        static let cachedReferencesKey = "courses_manager_core_cached_references_key"
        static let coursesKey = "courses_manager_core_cached_courses_key"
    }
    
    private let defaultRequestWrapper = DefaultRequestWrapper()
}

// MARK: Public
extension CoursesManager {
    func retrieveCourses(forceUpdate: Bool) -> Single<[Course]> {
        forceUpdate ? downloadAndCacheCourses() : cachedCourses()
    }
}

// MARK: References
extension CoursesManager {
    // С 42 билда всегда пустой массив
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
private extension CoursesManager {
    func downloadAndCacheCourses() -> Single<[Course]> {
        guard let userToken = SessionManager().getSession()?.userToken else {
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
