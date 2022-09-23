//
//  OSlideWhenStudyView.swift
//  FNP
//
//  Created by Andrey Chernyshev on 11.07.2021.
//

import UIKit

final class OWhenStudyView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(title: "Onboarding.WhenStudy.Cell1",
                              image: "Onboarding.WhenStudy.Cell1",
                              tag: 0)
    lazy var cell2 = makeCell(title: "Onboarding.WhenStudy.Cell2",
                              image: "Onboarding.WhenStudy.Cell2",
                              tag: 1)
    lazy var cell3 = makeCell(title: "Onboarding.WhenStudy.Cell3",
                              image: "Onboarding.WhenStudy.Cell3",
                              tag: 2)
    lazy var cell4 = makeCell(title: "Onboarding.WhenStudy.Cell4",
                              image: "Onboarding.WhenStudy.Cell4",
                              tag: 3)
    lazy var cell5 = makeCell(title: "Onboarding.WhenStudy.Cell5",
                              image: "Onboarding.WhenStudy.Cell5",
                              tag: 4)
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        changeEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared
            .logEvent(name: "When Study Screen", parameters: [:])
    }
}

// MARK: Private
private extension OWhenStudyView {
    @objc
    func buttonTapped() {
        let selected = [
            self.cell1, self.cell2, self.cell3, self.cell4, self.cell5
        ]
        .filter { $0.isSelected }
        .map { $0.tag }
        
        scope.testWhen = selected
        
        onNext()
    }
    
    @objc
    func selected(tapGesture: UITapGestureRecognizer) {
        guard let cell = tapGesture.view as? OWhenStudyCell else {
            return
        }
        
        cell.isSelected = !cell.isSelected
        
        changeEnabled()
    }
    
    func changeEnabled() {
        let isEmpty = [
            cell1, cell2, cell3, cell4, cell5
        ]
        .filter { $0.isSelected }
        .isEmpty
        
        button.isEnabled = !isEmpty
        button.alpha = isEmpty ? 0.4 : 1
    }
}

// MARK: Make constraints
private extension OWhenStudyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 117.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell4.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell5.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            cell5.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            cell5.topAnchor.constraint(equalTo: cell4.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -70.scale : -40.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OWhenStudyView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.WhenStudy.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String, image: String, tag: Int) -> OWhenStudyCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selected(tapGesture:)))
        
        let view = OWhenStudyCell()
        view.tag = tag
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.isSelected = false
        view.title = title.localized
        view.imageView.image = UIImage(named: image)
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
        view.setAttributedTitle("Onboarding.Proceed".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
