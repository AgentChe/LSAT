//
//  CoursesViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class CoursesViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var selected = PublishRelay<CoursesCollectionElement>()
    lazy var store = PublishRelay<Void>()
    
    lazy var elements = makeElements()
    lazy var stored = makeStored()
    lazy var activity = RxActivityIndicator()
    
    private lazy var coursesManager = CoursesManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension CoursesViewModel {
    func makeElements() -> Driver<[CoursesCollectionElement]> {
        let selectedId = makeSelectedCourseId()
        
        let courses = coursesManager
            .retrieveCourses(forceUpdate: false)
            .map {
                $0.sorted(by: { $0.sort < $1.sort })
            }
            .asDriver(onErrorJustReturn: [])
        
        return Driver
            .combineLatest(selectedId, courses) { selectedId, courses -> [CoursesCollectionElement] in
                courses.map {
                    CoursesCollectionElement(course: $0, isSelected: $0.id == selectedId)
                }
            }
    }
    
    func makeSelectedCourseId() -> Driver<Int> {
        let initial = profileManager
            .obtainSelectedCourse(forceUpdate: false)
            .map { $0?.id ?? -1 }
            .asDriver(onErrorJustReturn: -1)
        
        let updated = selected
            .map { $0.course.id }
            .asDriver(onErrorDriveWith: .empty())
        
        return Driver.merge(initial, updated)
    }
    
    func makeStored() -> Driver<Void> {
        store
            .withLatestFrom(selected)
            .flatMapLatest { [weak self] element -> Observable<Void> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<Void> {
                    self.profileManager
                        .set(course: element.course)
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
                    .trackActivity(self.activity)
            }
            .asDriver(onErrorDriveWith: .never())
    }
}
