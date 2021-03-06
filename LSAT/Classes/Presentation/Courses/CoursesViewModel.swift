//
//  CoursesViewModel.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import RxSwift
import RxCocoa

final class CoursesViewModel {
    lazy var selected = PublishRelay<CoursesCollectionElement>()
    lazy var store = PublishRelay<Void>()
    
    lazy var activityIndicator = RxActivityIndicator()
    
    private lazy var coursesManager = CoursesManagerCore()
    
    lazy var elements = makeElements()
    lazy var stored = makeStored()
}

// MARK: Private
private extension CoursesViewModel {
    func makeElements() -> Driver<[CoursesCollectionElement]> {
        let selectedId = selected
            .map { $0.course.id }
            .asDriver(onErrorDriveWith: .empty())
            .startWith(-1)
        
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
    
    func makeStored() -> Driver<Void> {
        store
            .withLatestFrom(selected)
            .flatMapLatest { [weak self] element -> Driver<Void> in
                guard let self = self else {
                    return .empty()
                }
                
                return self.coursesManager
                    .rxSelect(course: element.course)
                    .trackActivity(self.activityIndicator)
                    .asDriver(onErrorDriveWith: .empty())
            }
            .asDriver(onErrorDriveWith: .empty())
    }
}
