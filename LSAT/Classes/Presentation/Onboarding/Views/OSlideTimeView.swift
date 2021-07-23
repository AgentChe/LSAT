//
//  OSlide7View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class OSlideTimeView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var casualCell = makeCell(image: "Onboarding.Time.Casual",
                                   title: "Onboarding.Time.CasualTitle",
                                   subtitle: "Onboarding.Time.CasualMin",
                                   tag: 1)
    lazy var regularCell = makeCell(image: "Onboarding.Time.Regular",
                                    title: "Onboarding.Time.RegularTitle",
                                    subtitle: "Onboarding.Time.RegularMin",
                                    tag: 2)
    lazy var seriousCell = makeCell(image: "Onboarding.Time.Serious",
                                    title: "Onboarding.Time.SeriousTitle",
                                    subtitle: "Onboarding.Time.SeriousMin",
                                    tag: 3)
    lazy var intenseCell = makeCell(image: "Onboarding.Time.Intense",
                                    title: "Onboarding.Time.IntenseTitle",
                                    subtitle: "Onboarding.Time.IntenseMin",
                                    tag: 4)
    lazy var button = makeButton()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var profileManager = ProfileManagerCore()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        changeEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Test Time Screen", parameters: [:])
    }
}

// MARK: Private
private extension OSlideTimeView {
    func initialize() {
        button.rx.tap
            .flatMapLatest { [weak self] _ -> Single<Bool> in
                guard let self = self else {
                    return .never()
                }

                guard let tag = [
                    self.casualCell,
                    self.regularCell,
                    self.seriousCell,
                    self.intenseCell
                ]
                .first(where: { $0.isSelected })?
                .tag else {
                    return .never()
                }
                
                let time = tag * 5
                
                return self.profileManager
                    .set(testMinutes: time)
                    .map { true }
                    .catchAndReturn(false)
            }
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { [weak self] success in
                guard success else {
                    Toast.notify(with: "Onboarding.FailedToSave".localized, style: .danger)
                    return
                }

                self?.onNext()
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func selected(tapGesture: UITapGestureRecognizer) {
        guard let cell = tapGesture.view as? OTimeCell else {
            return
        }
        
        [
            casualCell,
            regularCell,
            seriousCell,
            intenseCell
        ].forEach { $0.isSelected = false }
        
        cell.isSelected = true
        
        changeEnabled()
    }
    
    func changeEnabled() {
        let isEmpty = [
            casualCell,
            regularCell,
            seriousCell,
            intenseCell
        ]
        .filter { $0.isSelected }
        .isEmpty
        
        button.isEnabled = !isEmpty
        button.alpha = isEmpty ? 0.4 : 1
    }
}

// MARK: Make constraints
private extension OSlideTimeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 117.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            casualCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            casualCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            casualCell.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 44.scale : 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            regularCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            regularCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            regularCell.topAnchor.constraint(equalTo: casualCell.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            seriousCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            seriousCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            seriousCell.topAnchor.constraint(equalTo: regularCell.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            intenseCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            intenseCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            intenseCell.topAnchor.constraint(equalTo: seriousCell.bottomAnchor, constant: 12.scale)
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
private extension OSlideTimeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Time.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(image: String,
                  title: String,
                  subtitle: String,
                  tag: Int) -> OTimeCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selected(tapGesture:)))
        
        let view = OTimeCell()
        view.tag = tag
        view.imageView.image = UIImage(named: image)
        view.title = title.localized
        view.subtitle = subtitle.localized
        view.isSelected = false
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Appearance.mainColor
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Onboarding.Next".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
