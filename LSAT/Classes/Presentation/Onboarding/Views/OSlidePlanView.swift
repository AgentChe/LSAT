//
//  OSlide15View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa

final class OSlidePlanView: OSlideView {
    weak var vc: UIViewController?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var chartView = makeChartView()
    lazy var cell1 = makeCell(title: "Onboarding.SlidePlan.Cell1", image: "Onboarding.SlidePlan.Cell1")
    lazy var cell2 = makeCell(title: "Onboarding.SlidePlan.Cell2", image: "Onboarding.SlidePlan.Cell2")
    lazy var cell3 = makeCell(title: "Onboarding.SlidePlan.Cell3", image: "Onboarding.SlidePlan.Cell3")
    lazy var cell4 = makeCell(title: "Onboarding.SlidePlan.Cell4", image: "Onboarding.SlidePlan.Cell4")
    lazy var button = makeButton()
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var tryAgainTrigger = PublishRelay<Void>()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        chartView.play()
        
        AmplitudeManager.shared
            .logEvent(name: "Personal Plan Screen", parameters: [:])
    }
}

// MARK: Private
private extension OSlidePlanView {
    func initialize() {
        Observable.merge(button.rx.tap.asObservable(), tryAgainTrigger.asObservable())
            .flatMapLatest { [weak self] _ -> Single<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                return self.profileManager
                    .set(examDate: self.scope.examDate,
                         testMode: self.scope.testMode,
                         testMinutes: self.scope.testMinutes,
                         testNumber: self.scope.testNumber,
                         testWhen: self.scope.testWhen,
                         notificationKey: self.scope.pushToken)
                    .map { true }
                    .catchAndReturn(false)
            }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] success in
                guard let self = self else {
                    return
                }
                
                success ? self.onNext() : self.openError()
            })
            .disposed(by: disposeBag)
    }
    
    func openError() {
        let tryAgainVC = TryAgainViewController.make { [weak self] in
            guard let self = self else {
                return
            }
            
            self.tryAgainTrigger.accept(Void())
        }
        vc?.present(tryAgainVC, animated: true)
    }
}

// MARK: Make constraints
private extension OSlidePlanView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 84.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9.scale),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9.scale),
            chartView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 179.scale : 110.scale),
            chartView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 294.scale : 265.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell1.bottomAnchor.constraint(equalTo: cell2.topAnchor, constant: -5.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell2.bottomAnchor.constraint(equalTo: cell3.topAnchor, constant: -5.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell3.bottomAnchor.constraint(equalTo: cell4.topAnchor, constant: -5.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell4.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell4.bottomAnchor.constraint(equalTo: button.topAnchor, constant: ScreenSize.isIphoneXFamily ? -32.scale : -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -70.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlidePlanView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.bold(size: 25.scale))
            .lineHeight(29.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlidePlan.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeChartView() -> AnimationView {
        let view = AnimationView()
        view.animation = Animation.named("Onboarding.Chart")
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String, image: String) -> OSlidePlanCell {
        let view = OSlidePlanCell()
        view.label.text = title.localized
        view.imageView.image = UIImage(named: image)
        view.imageView.image = view.imageView.image?.withRenderingMode(.alwaysTemplate)
        view.imageView.tintColor = Appearance.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .lineHeight(23.scale)
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Appearance.mainColor
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Onboarding.SlidePlan.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
