//
//  ReviewCoordinator.swift
//  Nursing
//
//  Created by Андрей Чернышев on 17.06.2022.
//

import UIKit

final class ReviewCoordinator {
    weak var parentVC: ReviewViewController?
    
    lazy var quizesVC = QuizesViewController.make()
    lazy var questionsVC = ReviewQuestionsViewController.make()
    
    private var previousVC: UIViewController?
    
    init(parentVC: ReviewViewController) {
        self.parentVC = parentVC
    }
    
    func change(filter: ReviewFilterView.Filter) {
        parentVC?.mainView.filterView.selectedTab = filter
        
        switch filter {
        case .quizes:
            changeVC(on: quizesVC)
        case .questions:
            changeVC(on: questionsVC)
        }
    }
}

// MARK: Private
private extension ReviewCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC = self.parentVC else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = parentVC.mainView.container.bounds
        parentVC.mainView.container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
