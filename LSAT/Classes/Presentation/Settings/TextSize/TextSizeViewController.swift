//
//  TextSizeViewController.swift
//  Nursing
//
//  Created by Андрей Чернышев on 25.05.2022.
//

import UIKit
import RxSwift

final class TextSizeViewController: UIViewController {
    lazy var mainView = TextSizeView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = TextSizeViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentTextSize
            .drive(onNext: { [weak self] textSize in
                self?.mainView.setup(textSize: textSize)
            })
            .disposed(by: disposeBag)
        
        mainView.minusButton.rx.tap
            .bind(to: viewModel.minus)
            .disposed(by: disposeBag)
        
        mainView.plusButton.rx.tap
            .bind(to: viewModel.plus)
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension TextSizeViewController {
    static func make() -> TextSizeViewController {
        let vc = TextSizeViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}
