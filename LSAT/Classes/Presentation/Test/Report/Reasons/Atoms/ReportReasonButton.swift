//
//  ReportReasonButton.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import UIKit

final class ReportReasonButton: UIButton {
    var isChecked: Bool = false {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    
    let reason: ReportReason
    
    init(reason: ReportReason) {
        self.reason = reason
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ReportReasonButton {
    func update() {
        layer.borderWidth = isChecked ? 3.scale : 0
        layer.borderColor = isChecked ? Appearance.mainColor.cgColor : UIColor.clear.cgColor
    }
    
    func text() -> String {
        switch reason {
        case .answerIsWrong:
            return "ReportReason.Reason1".localized
        case .caughtTypo:
            return "ReportReason.Reason2".localized
        case .confusing:
            return "ReportReason.Reason3".localized
        case .notWorking:
            return "ReportReason.Reason4".localized
        }
    }
}

// MARK: Make constraints
private extension ReportReasonButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReportReasonButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(20.scale)
        
        let view = UILabel()
        view.attributedText = text().attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
