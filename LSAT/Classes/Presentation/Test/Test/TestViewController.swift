//
//  TestViewController.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import AVKit
import RushSDK

final class TestViewController: UIViewController {
    lazy var mainView = TestView(testType: testType)
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TestViewModel()
    
    var didTapSubmit: ((Int) -> Void)?
    
    private let testType: TestType
    
    private init(testType: TestType) {
        self.testType = testType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .empty()
            }
            
            return self.openError()
        }
        
        viewModel.loadTestActivityIndicator
            .drive(Binder(self) { base, activity in
                base.mainView.tableView.isHidden = activity
                activity ? base.mainView.activityView.startAnimating() : base.mainView.activityView.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        viewModel.sendAnswerActivityIndicator
            .drive(Binder(self) { base, activity in
                activity ? base.mainView.bottomView.preloader.start() : base.mainView.bottomView.preloader.stop()
            })
            .disposed(by: disposeBag)
        
        viewModel.vibration
            .drive(Binder(self) { base, isSuccess in
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(isSuccess ? .success : .error)
            })
            .disposed(by: disposeBag)
        
        mainView.tabView.favoriteButton.rx.tap
            .withLatestFrom(viewModel.isSavedQuestion)
            .bind(to: viewModel.didTapMark)
            .disposed(by: disposeBag)
        
        viewModel.isSavedQuestion
            .drive(Binder(self) { base, isSaved in
                base.update(favorite: isSaved)
            })
            .disposed(by: disposeBag)
        
        viewModel.progress
            .drive(Binder(self) { base, progress in
                base.update(progress: progress)
            })
            .disposed(by: disposeBag)
        
        viewModel.score
            .drive(Binder(self) { base, score in
                base.mainView.progressView.setProgress(score, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.testFinishElement
            .drive(Binder(self) { base, element in
                base.finishTest(result: .submit, element: element)
            })
            .disposed(by: disposeBag)
        
        viewModel.question
            .drive(Binder(self) { base, element in
                base.mainView.tableView.setup(question: element)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .selectedAnswersRelay
            .withLatestFrom(viewModel.courseName) { ($0, $1) }
            .bind(to: Binder(self) { base, args in
                let (answers, name) = args
                
                base.viewModel.answers.accept(answers)
                base.logTapAnalytics(courseName: name, what: "answer")
            })
            .disposed(by: disposeBag)
        
        viewModel.bottomViewState
            .startWith(.hidden)
            .drive(Binder(mainView.bottomView) {
                $0.setup(state: $1)
            })
            .disposed(by: disposeBag)
        
        let currentButtonState = mainView.bottomView.button.rx.tap
            .withLatestFrom(viewModel.bottomViewState)
            .share()
        
        currentButtonState
            .compactMap { $0 == .confirm ? () : nil }
            .bind(to: viewModel.didTapConfirm)
            .disposed(by: disposeBag)
        
        currentButtonState
            .compactMap { $0 == .submit ? () : nil }
            .withLatestFrom(viewModel.questions)
            .bind(to: Binder(self) { base, questions in
                let allQuestionsCount = questions.count
                let answeredQuestionsCount = questions.filter { $0.isAnswered }.count
                
                if allQuestionsCount == answeredQuestionsCount {
                    base.viewModel.didTapSubmit.accept(Void())
                    
                    return
                }
                
                let vc = SubmitQuizViewController.make(allQuestionsCount: allQuestionsCount,
                                                       answeredQuestionsCount: answeredQuestionsCount) { result in
                    switch result {
                    case .submit:
                        base.viewModel.didTapSubmit.accept(Void())
                    }
                }
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { $0 == .back }
            .bind(to: Binder(self) { base, _ in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { $0 == .next }
            .withLatestFrom(viewModel.courseName)
            .bind(to: Binder(self) { base, name in
                base.viewModel.didTapNext.accept(Void())
                base.logTapAnalytics(courseName: name, what: "continue")
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .withLatestFrom(viewModel.testType)
            .compactMap { $0 }
            .filter { $0.isQotd() }
            .withLatestFrom(viewModel.courseName)
            .bind(to: Binder(self) { base, courseName in
                base.logTapAnalytics(courseName: courseName, what: "close")
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .withLatestFrom(viewModel.testType)
            .compactMap { $0 }
            .filter { !$0.isQotd() }
            .withLatestFrom(viewModel.courseName)
            .withLatestFrom(viewModel.questions) { ($0, $1) }
            .withLatestFrom(viewModel.userTestId) { ($0.0, $0.1, $1) }
            .bind(to: Binder(self) { base, args in
                let (courseName, questions, userTestId) = args

                let vc = QuitQuizViewController.make(allQuestionsCount: questions.count,
                                                     answeredQuestionsCount: questions.filter { $0.isAnswered }.count) { result in
                    let element = TestFinishElement(userTestId: userTestId,
                                                    courseName: courseName,
                                                    testType: base.testType)
                    switch result {
                    case .quit:
                        base.finishTest(result: .quit, element: element)
                    case .submit:
                        base.viewModel.didTapSubmit.accept(Void())
                    }
                }
                base.present(vc, animated: false)
            })
            .disposed(by: disposeBag)
    
        viewModel.isEndOfTest
            .filter(!)
            .withLatestFrom(viewModel.testMode)
            .bind(with: self, onNext: { base, testMode in
                if testMode == .onAnExam {
                    base.viewModel.didTapNext.accept(Void())
                }
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .expandContent
            .bind(to: Binder(self) { base, content in
                switch content {
                case let .image(url):
                    let controller = PhotoViewController.make(imageURL: url)
                    base.present(controller, animated: true)
                case let .video(url):
                    let controller = AVPlayerViewController()
                    controller.view.backgroundColor = .black
                    let player = AVPlayer(url: url)
                    controller.player = player
                    base.present(controller, animated: true) { [weak player] in
                        player?.play()
                    }
                }
            })
            .disposed(by: disposeBag)

        viewModel.needPayment
            .filter { $0 }
            .emit { [weak self] _ in
                self?.dismiss(animated: true, completion: {
                    UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(PaygateViewController.make(), animated: true)
                })
            }
            .disposed(by: disposeBag)
            
        viewModel.needPayment
            .filter(!)
            .withLatestFrom(viewModel.courseName)
            .emit(onNext: { [weak self] name in
                self?.logAnalytics(courseName: name)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView
            .expandContent
            .withLatestFrom(viewModel.courseName)
            .subscribe(onNext: { [weak self] name in
                self?.logTapAnalytics(courseName: name, what: "media")
            })
            .disposed(by: disposeBag)
        
        currentButtonState
            .filter { [.submit, .back].contains($0) }
            .withLatestFrom(viewModel.needPayment)
            .subscribe(onNext: { needPayment in
                guard !needPayment else { return }
                RateManagerCore().showFirstAfterPassRateAlert()
            })
            .disposed(by: disposeBag)
        
        mainView.menuButton.rx.tap
            .withLatestFrom(viewModel.question)
            .withLatestFrom(viewModel.userTestId) { ($0.id, $1) }
            .bind(to: Binder(self) { base, args in
                let (questionId, userTestId) = args
                
                let vc = ReportOptionsViewController.make(questionId: questionId, userTestId: userTestId)
                vc.delegate = base
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.tabView.reportButton.rx.tap
            .withLatestFrom(viewModel.question)
            .withLatestFrom(viewModel.userTestId) { ($0.id, $1) }
            .bind(to: Binder(self) { base, args in
                let (questionId, userTestId) = args
                
                let vc = ReportReasonsViewController.make(questionId: questionId,
                                                          userTestId: userTestId,
                                                          reason: nil)
                vc.delegate = base
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.tabView.nextButton.rx.tap
            .bind(to: viewModel.didTapNextQuestion)
            .disposed(by: disposeBag)
        
        mainView.tabView.previousButton.rx.tap
            .bind(to: viewModel.didTapPreviousQuestion)
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TestViewController {
    static func make(testType: TestType, activeSubscription: Bool) -> TestViewController {
        let controller = TestViewController(testType: testType)
        controller.modalPresentationStyle = .fullScreen
        controller.viewModel.activeSubscription = activeSubscription
        controller.viewModel.testType.accept(testType)
        return controller
    }
}

// MARK: ReportOptionsViewControllerDelegate
extension TestViewController: ReportOptionsViewControllerDelegate {
    func reportOptionsDidTappedReport(questionId: Int, userTestId: Int) {
        let vc = ReportReasonsViewController.make(questionId: questionId, userTestId: userTestId, reason: nil)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func reportOptionsDidTappedRestart(userTestId: Int) {
        viewModel.didTapRestart.accept(userTestId)
    }
}

// MARK: ReportReasonsViewControllerDelegate
extension TestViewController: ReportReasonsViewControllerDelegate {
    func reportReasonDidTappedBack(questionId: Int, userTestId: Int) {
        let vc = ReportOptionsViewController.make(questionId: questionId, userTestId: userTestId)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func reportReasonDidSelected(questionId: Int, userTestId: Int, reason: ReportReason) {
        let vc = ReportViewController.make(questionId: questionId, userTestId: userTestId, reason: reason)
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: ReportViewControllerDelegate
extension TestViewController: ReportViewControllerDelegate {
    func reportViewControllerDidTappedBack(questionId: Int, userTestId: Int, reason: ReportReason) {
        let vc = ReportReasonsViewController.make(questionId: questionId, userTestId: userTestId, reason: reason)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func reportViewControllerDidReported() {
        Toast.notify(with: "Report.Success".localized, style: .success)
    }
}

// MARK: Private
private extension TestViewController {
    func update(favorite: Bool) {
        let image = UIImage(named: favorite ? "Question.Favorite.Check" : "Question.Favorite.Uncheck")
        mainView.tabView.favoriteButton.setImage(image, for: .normal)
    }
    
    func update(progress: String) {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        let timedAttrs = TextAttributes()
            .textColor(Appearance.mainColor)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        switch testType {
        case .qotd:
            mainView.titleLabel.attributedText = "Question.TodayTitle".localized.attributed(with: attrs)
        case .timed:
            mainView.titleLabel.attributedText = progress.attributed(with: timedAttrs)
        default:
            mainView.titleLabel.attributedText = progress.attributed(with: attrs)
        }
    }
    
    func finishTest(result: QuitQuizViewController.Result, element: TestFinishElement) {
        switch result {
        case .quit:
            logTapAnalytics(courseName: element.courseName, what: "close")
            
            QuestionMediator.shared.notifyAboudTestClosed(with: element)
            
            dismiss(animated: true)
        case .submit:
            logTapAnalytics(courseName: element.courseName, what: "finish test")
            
            didTapSubmit?(element.userTestId)
        }
    }
    
    func logAnalytics(courseName: String) {
        guard let type = viewModel.testType.value else {
            return
        }
        
        let name = TestAnalytics.name(mode: type)
        
        SDKStorage.shared.amplitudeManager
            .logEvent(name: "Question Screen", parameters: ["course": courseName,
                                                            "mode": name])
    }
    
    func logTapAnalytics(courseName: String, what: String) {
        guard let type = viewModel.testType.value else {
            return
        }
        
        let name = TestAnalytics.name(mode: type)
        
        SDKStorage.shared.amplitudeManager
            .logEvent(name: "Question Tap", parameters: ["course": courseName,
                                                         "mode": name,
                                                         "what": what])
    }
    
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
}
