//
//  CoursesViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift
import RushSDK

protocol CoursesViewControllerDelegate: AnyObject {
    func coursesViewControllerDismissed()
}

final class CoursesViewController: UIViewController {
    enum HowOpen {
        case root, present
    }
    
    weak var delegate: CoursesViewControllerDelegate?
    
    lazy var mainView = CoursesView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = CoursesViewModel()
    
    private let howOpen: HowOpen
    
    private init(howOpen: HowOpen) {
        self.howOpen = howOpen
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Exam Screen", parameters: [:])
        
        mainView
            .collectionView.selected
            .subscribe(onNext: { [weak self] element in
                self?.viewModel.selected.accept(element)
                self?.logAnalytics(selected: element)
            })
            .disposed(by: disposeBag)

        viewModel
            .elements
            .drive(onNext: mainView.collectionView.setup(elements:))
            .disposed(by: disposeBag)
        
        mainView
            .button.rx.tap
            .bind(to: viewModel.store)
            .disposed(by: disposeBag)
        
        viewModel
            .stored
            .drive(onNext: { [weak self] in
                self?.goToNext()
            })
            .disposed(by: disposeBag)
        
        viewModel.activityIndicator
            .drive(onNext: { [weak self] activity in
                guard let self = self else {
                    return
                }
                
                self.activity(activity)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension CoursesViewController {
    static func make(howOpen: HowOpen) -> CoursesViewController {
        let vc = CoursesViewController(howOpen: howOpen)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension CoursesViewController {
    func goToNext() {
        switch howOpen {
        case .root:
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController = CourseViewController.make()
        case .present:
            dismiss(animated: true) { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.delegate?.coursesViewControllerDismissed()
            }
        }
    }
    
    func logAnalytics(selected element: CoursesCollectionElement) {
        let name = element.course.name
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Exam Tap", parameters: ["what":name])
    }
    
    func activity(_ activity: Bool) {
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
        
        mainView.buttonTitle(hidden: activity)
    }
}
