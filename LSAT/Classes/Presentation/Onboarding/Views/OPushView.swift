//
//  OPushView.swift
//  FNP
//
//  Created by Andrey Chernyshev on 11.07.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class OPushView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subtitleLabel = makeSubtitleLabel()
    lazy var imageView = makeImageView()
    lazy var allowButton = makeAllowButton()
    lazy var notNowButton = makeNotNowButton()
    
    private lazy var sendToken = PublishRelay<String>()
    
    private lazy var manager = ProfileManagerCore()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        SDKStorage.shared
            .pushNotificationsManager
            .add(observer: self)
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Notifications Screen", parameters: [:])
    }
}

// MARK:
extension OPushView: PushNotificationsManagerDelegate {
    func pushNotificationsManagerDidReceive(token: String?) {
        SDKStorage.shared
            .pushNotificationsManager
            .remove(observer: self)
        
        guard let token = token else {
            onNext()
            return
        }
        
        sendToken.accept(token)
    }
}

// MARK: Private
private extension OPushView {
    func initialize() {
        allowButton.rx.tap
            .subscribe(onNext: {
                SDKStorage.shared
                    .pushNotificationsManager
                    .requestAuthorization()
            })
            .disposed(by: disposeBag)
        
        sendToken
            .flatMapLatest { [weak self] token -> Single<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                return self.manager
                    .set(notificationKey: token)
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
}

// MARK: Make constraints
private extension OPushView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 134.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 270.scale),
            imageView.widthAnchor.constraint(equalToConstant: 269.scale),
            imageView.bottomAnchor.constraint(equalTo: allowButton.topAnchor, constant: ScreenSize.isIphoneXFamily ? -86.scale : -56.scale)
        ])
        
        NSLayoutConstraint.activate([
            allowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            allowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            allowButton.heightAnchor.constraint(equalToConstant: 60.scale),
            allowButton.bottomAnchor.constraint(equalTo: notNowButton.topAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            notNowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            notNowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            notNowButton.heightAnchor.constraint(equalToConstant: 25.scale),
            notNowButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -30.scale : -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OPushView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Push.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubtitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 75, green: 81, blue: 102))
            .font(Fonts.SFProRounded.regular(size: 20.scale))
            .lineHeight(28.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Push.Subtitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Push.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAllowButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = Appearance.mainColor
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Onboarding.Proceed".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNotNowButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.regular(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.setAttributedTitle("Onboarding.Push.NotNow".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
