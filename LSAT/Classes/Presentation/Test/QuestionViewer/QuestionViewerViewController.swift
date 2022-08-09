//
//  QuestionViewerViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 20.06.2022.
//

import UIKit
import RxSwift
import AVFoundation
import AVKit

final class QuestionViewerViewController: UIViewController {
    lazy var mainView = QuestionViewerView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: QuestionViewerViewModel
    
    private init(reviews: [Review], current: Review) {
        viewModel = QuestionViewerViewModel(reviews: reviews,
                                            current: current)
        
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
        
        mainView.tabView.favoriteButton.rx.tap
            .withLatestFrom(viewModel.isSavedQuestion)
            .bind(to: viewModel.didTapMark)
            .disposed(by: disposeBag)
        
        viewModel.isSavedQuestion
            .drive(Binder(self) { base, isSaved in
                base.update(favorite: isSaved)
            })
            .disposed(by: disposeBag)
        
        mainView.tabView.previousButton.rx.tap
            .withLatestFrom(viewModel.currentIndex) { $1 - 1 }
            .bind(to: viewModel.didTapPrevious)
            .disposed(by: disposeBag)
        
        mainView.tabView.nextButton.rx.tap
            .withLatestFrom(viewModel.currentIndex) { $1 + 1 }
            .bind(to: viewModel.didTapNext)
            .disposed(by: disposeBag)
        
        viewModel.score
            .drive(Binder(self) { base, score in
                base.update(score: score)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(self) { base, elements in
                base.mainView.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension QuestionViewerViewController {
    static func make(reviews: [Review], current: Review) -> QuestionViewerViewController {
        let vc = QuestionViewerViewController(reviews: reviews, current: current)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: QuestionViewerTableDelegate
extension QuestionViewerViewController: QuestionViewerTableDelegate {
    func questionViewerTableDidExpand(contentType: QuestionContentType) {
        switch contentType {
        case let .image(url):
            let controller = PhotoViewController.make(imageURL: url)
            present(controller, animated: true)
        case let .video(url):
            let controller = AVPlayerViewController()
            controller.view.backgroundColor = UIColor.black
            let player = AVPlayer(url: url)
            controller.player = player
            present(controller, animated: true) { [weak player] in
                player?.play()
            }
        }
    }
}

// MARK: Private
private extension QuestionViewerViewController {
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
    
    func update(favorite: Bool) {
        let image = UIImage(named: favorite ? "Question.Favorite.Check" : "Question.Favorite.Uncheck")
        mainView.tabView.favoriteButton.setImage(image, for: .normal)
    }

    func update(score: String) {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(22.scale)
        mainView.questionsCountLabel.attributedText = score.attributed(with: attrs)
    }
}
