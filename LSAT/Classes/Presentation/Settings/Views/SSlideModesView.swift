//
//  SSlideModesView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 31.03.2022.
//

import UIKit
import RxSwift
import RxCocoa
import RushSDK

final class SSlideModesView: SSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var fullSupportCell = makeCell(image: "Onboarding.Modes.Cell1",
                                        title: "Onboarding.Modes.Cell1.Title",
                                        subtitle: "Onboarding.Modes.Cell1.Subtitle",
                                        tag: 0)
    lazy var withoutExplanationsCell = makeCell(image: "Onboarding.Modes.Cell2",
                                                title: "Onboarding.Modes.Cell2.Title",
                                                subtitle: "Onboarding.Modes.Cell2.Subtitle",
                                                tag: 1)
    lazy var examStyleCell = makeCell(image: "Onboarding.Modes.Cell3",
                                      title: "Onboarding.Modes.Cell3.Title",
                                      subtitle: "Onboarding.Modes.Cell3.Subtitle",
                                      tag: 2)
    lazy var button = makeButton()
    lazy var preloader = makePreloader()
    
    private lazy var activityIndicator = RxActivityIndicator()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var profileManager = ProfileManagerCore()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        changeEnabled()
        setup(buttonTitle: "Continue".localized)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        SDKStorage.shared
            .amplitudeManager
            .logEvent(name: "Exam Mode Screen", parameters: [:])
    }
}

// MARK: Public
extension SSlideModesView {
    func setup(mode: TestMode) {
        switch mode {
        case .fullComplect:
            changeSelected(selectedCell: fullSupportCell)
        case .noExplanations:
            changeSelected(selectedCell: withoutExplanationsCell)
        case .onAnExam:
            changeSelected(selectedCell: examStyleCell)
        }
    }
}

// MARK: Private
private extension SSlideModesView {
    func initialize() {
        button.rx.tap
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }

                guard let mode = [
                    self.fullSupportCell,
                    self.withoutExplanationsCell,
                    self.examStyleCell
                ]
                .first(where: { $0.isSelected })?
                .tag else {
                    return .never()
                }
                
                return self.profileManager
                    .set(testMode: mode)
                    .trackActivity(self.activityIndicator)
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
        
        button.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                
                let mode = [
                    self.fullSupportCell,
                    self.withoutExplanationsCell,
                    self.examStyleCell
                ]
                .first(where: { $0.isSelected })?
                .tag
                
                switch mode {
                case 0:
                    SDKStorage.shared
                        .amplitudeManager
                        .logEvent(name: "Exam Mode Tap", parameters: ["what": "full support"])
                case 1:
                    SDKStorage.shared
                        .amplitudeManager
                        .logEvent(name: "Exam Mode Tap", parameters: ["what": "without explanations"])
                case 2:
                    SDKStorage.shared
                        .amplitudeManager
                        .logEvent(name: "Exam Mode Tap", parameters: ["what": "exam style"])
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        activityIndicator
            .drive(onNext: { [weak self] activity in
                guard let self = self else {
                    return
                }
                
                self.activity(activity)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func selected(tapGesture: UITapGestureRecognizer) {
        guard let cell = tapGesture.view as? OModeCell else {
            return
        }
        
        changeSelected(selectedCell: cell)
    }
    
    func changeSelected(selectedCell: OModeCell) {
        [
            fullSupportCell,
            withoutExplanationsCell,
            examStyleCell
        ].forEach { $0.isSelected = false }
        
        selectedCell.isSelected = true
        
        changeEnabled()
    }
    
    func changeEnabled() {
        let isEmpty = [
            fullSupportCell,
            withoutExplanationsCell,
            examStyleCell
        ]
        .filter { $0.isSelected }
        .isEmpty
        
        button.isEnabled = !isEmpty
        button.alpha = isEmpty ? 0.4 : 1
    }
    
    func activity(_ activity: Bool) {
        let title = activity ? "" : "Continue".localized
        setup(buttonTitle: title)
        
        activity ? preloader.startAnimating() : preloader.stopAnimating()
    }
    
    func setup(buttonTitle: String) {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textAlignment(.center)
        button.setAttributedTitle(buttonTitle.attributed(with: attrs), for: .normal)
    }
}

// MARK: Make constraints
private extension SSlideModesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 117.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            fullSupportCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            fullSupportCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            fullSupportCell.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 40.scale : 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            withoutExplanationsCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            withoutExplanationsCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            withoutExplanationsCell.topAnchor.constraint(equalTo: fullSupportCell.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            examStyleCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            examStyleCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            examStyleCell.topAnchor.constraint(equalTo: withoutExplanationsCell.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -70.scale : -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 24.scale),
            preloader.heightAnchor.constraint(equalToConstant: 24.scale),
            preloader.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SSlideModesView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.4.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Modes.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(image: String,
                  title: String,
                  subtitle: String,
                  tag: Int) -> OModeCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selected(tapGesture:)))
        
        let view = OModeCell()
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
        let view = UIButton()
        view.backgroundColor = Appearance.mainColor
        view.layer.cornerRadius = 30.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 24.scale, height: 24.scale), style: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
