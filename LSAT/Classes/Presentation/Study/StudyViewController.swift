//
//  StudyViewController.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit
import RxSwift

final class StudyViewController: UIViewController {
    lazy var mainView = StudyView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = StudyViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activeSubscription = viewModel.activeSubscription
        
        viewModel
            .courseName
            .drive(onNext: { name in
                SDKStorage.shared
                    .amplitudeManager
                    .logEvent(name: "Study Screen", parameters: ["exam": name])
            })
            .disposed(by: disposeBag)
        
        viewModel
            .sections
            .drive(onNext: { [weak self] sections in
                self?.mainView.collectionView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        mainView
            .settingsButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.settingsTapped()
            })
            .disposed(by: disposeBag)
        
        mainView
            .collectionView.selected
            .withLatestFrom(activeSubscription) { ($0, $1) }
            .subscribe(onNext: { [weak self] stub in
                let (element, activeSubscription) = stub
 
                self?.selected(element: element, activeSubscription: activeSubscription)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension StudyViewController {
    static func make() -> StudyViewController {
        let vc = StudyViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension StudyViewController {
    func settingsTapped() {
        navigationController?.pushViewController(SettingsViewController.make(), animated: true)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Study Tap", parameters: ["what": "settings"])
    }
    
    func selected(element: StudyCollectionElement, activeSubscription: Bool) {
        switch element {
        case .brief, .title:
            break
        case .unlockAllQuestions:
            openPaygate()
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "unlock all questions"])
        case .takeTest(let activeSubscription):
            openTest(type: .get(testId: nil), activeSubscription: activeSubscription)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "take a free test"])
        case .mode(let mode):
            tapped(mode: mode.mode, activeSubscription: activeSubscription)
        }
    }
    
    func tapped(mode: SCEMode.Mode, activeSubscription: Bool) {
        switch mode {
        case .ten:
            openTest(type: .tenSet, activeSubscription: activeSubscription)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "10 questions"])
        case .random:
            openTest(type: .randomSet, activeSubscription: activeSubscription)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "random set"])
        case .missed:
            openTest(type: .failedSet, activeSubscription: activeSubscription)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "missed questions"])
        case .today:
            openTest(type: .qotd, activeSubscription: activeSubscription)
            
            SDKStorage.shared
                .amplitudeManager
                .logEvent(name: "Study Tap", parameters: ["what": "question of the day"])
        }
    }
    
    func openTest(type: TestType, activeSubscription: Bool) {
        let controller = TestViewController.make(testType: type, activeSubscription: activeSubscription)
        controller.didTapSubmit = { [weak self] userTestId in
            self?.dismiss(animated: false, completion: { [weak self] in
                self?.present(TestStatsViewController.make(userTestId: userTestId, testType: type), animated: true)
            })
        }
        present(controller, animated: true)
    }
    
    func openPaygate() {
        UIApplication.shared.keyWindow?.rootViewController?.present(PaygateViewController.make(), animated: true)
    }
}
