//
//  ReviewViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 17.06.2022.
//

import UIKit
import RxSwift

final class ReviewViewController: UIViewController {
    lazy var mainView = ReviewView()
    
    private lazy var viewModel = ReviewViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = ReviewCoordinator(parentVC: self)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, _ in
                base.update(selectedTab: .quizes)
            })
            .disposed(by: disposeBag)
        
        addActionsToTabs()
    }
}

// MARK: Make
extension ReviewViewController {
    static func make() -> ReviewViewController {
        let vc = ReviewViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension ReviewViewController {
    func addActionsToTabs() {
        Observable
            .merge([
                mainView.filterView.quizesButton
                    .rx.tap.map { ReviewFilterView.Filter.quizes },
                
                mainView.filterView.questionsButton
                    .rx.tap.map { ReviewFilterView.Filter.questions }
            ])
            .subscribe(onNext: { [weak self] tab in
                self?.update(selectedTab: tab)
            })
            .disposed(by: disposeBag)
    }
    
    func update(selectedTab: ReviewFilterView.Filter) {
        coordinator.change(filter: selectedTab)
    }
}
