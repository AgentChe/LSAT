//
//  ReviewQuestionsViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 19.06.2022.
//

import UIKit
import RxSwift
import RxCocoa

final class ReviewQuestionsViewController: UIViewController {
    lazy var mainView = ReviewQuestionsView()
    
    private lazy var viewModel = ReviewQuestionsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.openError()
        }
        
        let elements = viewModel.elements
        let activity = viewModel.activity
        
        elements
            .drive(Binder(self) { base, elements in
                base.mainView.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        Driver
            .merge(
                viewModel.elements.map { !$0.isEmpty },
                viewModel.activity.filter { $0 }
            )
            .drive(Binder(self) { base, isHidden in
                base.mainView.emptyLabel.isHidden = isHidden
            })
            .disposed(by: disposeBag)
        
        addFilterTappedActions()
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension ReviewQuestionsViewController {
    static func make() -> ReviewQuestionsViewController {
        ReviewQuestionsViewController()
    }
}

// MARK: ReviewQuestionsTableViewDelegate
extension ReviewQuestionsViewController: ReviewQuestionsTableViewDelegate {
    func reviewQuestionsTableDidReachedBottom() {
        viewModel.nextPage.accept(Void())
    }
    
    func reviewQuestionsTableDidTapped(element: Review) {
        let reviews = mainView.tableView.elements
            .compactMap { element -> Review? in
                guard case let .review(review) = element else {
                    return nil
                }
                
                return review
            }
        
        
        let vc = QuestionViewerViewController.make(reviews: reviews,
                                                   current: element)
        present(vc, animated: true)
    }
}

// MARK: Private
private extension ReviewQuestionsViewController {
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
    
    func addFilterTappedActions() {
        Observable
            .merge(
                mainView.filterView.allButton.rx.tap.map { ReviewQuestionsFilter.all },
                mainView.filterView.correctButton.rx.tap.map { ReviewQuestionsFilter.correct },
                mainView.filterView.incorrectButton.rx.tap.map { ReviewQuestionsFilter.incorrect }
            )
            .startWith(.all)
            .distinctUntilChanged()
            .bind(to: Binder(self) { base, filter in
                base.mainView.filterView.filter = filter
                base.viewModel.filter.accept(filter)
                base.mainView.tableView.setup(elements: [])
            })
            .disposed(by: disposeBag)
    }
    
    func activity(_ activity: Bool) {
        if activity {
            let footerView = UIView()
            footerView.frame.size = CGSize(width: 375.scale, height: 50.scale)
            footerView.backgroundColor = UIColor.clear
            
            let preloader = Spinner(size: CGSize(width: 24.scale, height: 24.scale))
            preloader.frame.origin = CGPoint(x: footerView.frame.width / 2 - preloader.intrinsicContentSize.width / 2,
                                             y: footerView.frame.height / 2 - preloader.intrinsicContentSize.height / 2)
            footerView.addSubview(preloader)
            
            mainView.tableView.tableFooterView = footerView
            
            preloader.startAnimating()
        } else {
            mainView.tableView.tableFooterView = nil
        }
    }
}
