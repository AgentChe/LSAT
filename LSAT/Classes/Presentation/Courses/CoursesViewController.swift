//
//  CoursesViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift

protocol CoursesViewControllerDelegate: AnyObject {
    func coursesViewControllerDismissed()
}

final class CoursesViewController: UIViewController {
    weak var delegate: CoursesViewControllerDelegate?
    
    lazy var mainView = CoursesView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = CoursesViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "Exam Screen", parameters: [:])
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        mainView.collectionView.selected
            .subscribe(onNext: { [weak self] element in
                self?.viewModel.selected.accept(element)
                self?.logAnalytics(selected: element)
            })
            .disposed(by: disposeBag)

        viewModel.elements
            .drive(onNext: { [weak self] elements in
                self?.mainView.collectionView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.button.rx.tap
            .bind(to: viewModel.store)
            .disposed(by: disposeBag)
        
        viewModel.stored
            .drive(onNext: { [weak self] in
                self?.dismiss()
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(onNext: { [weak self] activity in
                self?.activity(activity)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension CoursesViewController {
    static func make() -> CoursesViewController {
        let vc = CoursesViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension CoursesViewController {
    func openError() -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func dismiss() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.coursesViewControllerDismissed()
        }
    }
    
    func logAnalytics(selected element: CoursesCollectionElement) {
        let name = element.course.name
        
        AmplitudeManager.shared
            .logEvent(name: "Exam Tap", parameters: ["what":name])
    }
    
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
        
        mainView.buttonTitle(hidden: activity)
    }
}
