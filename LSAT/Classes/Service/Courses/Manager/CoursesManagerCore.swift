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
    func select(course: Course) {
        guard let data = try? JSONEncoder().encode(course) else {
            return
        }
        
        UserDefaults.standard.set(data, forKey: Constants.selectedCourseCacheKey)
    }
    
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
        Single<Void>
            .create { [weak self] event in
                self?.select(course: course)
                
                event(.success(Void()))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
    }
    
    func rxGetSelectedCourse() -> Single<Course?> {
        Single<Course?>
            .create { [weak self] event in
                let selectedCourse = self?.getSelectedCourse()
                
                event(.success(selectedCourse))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
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
