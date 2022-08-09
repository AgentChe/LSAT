//
//  ReportMessageView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 27.05.2022.
//

import UIKit

final class ReportMessageView: UIView {
    enum State {
        case none, focus
    }
    
    lazy var textView = makeTextView()
    lazy var placeholderLabel = makePlaceholderLabel()
    
    var editing: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        textViewDidChange(textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextViewDelegate
extension ReportMessageView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        editing?()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView === self.textView else {
            return
        }
        
        color(at: .focus)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView === self.textView else {
            return
        }
        
        color(at: .none)
    }
}

// MARK: Private
private extension ReportMessageView {
    func color(at state: State) {
        switch state {
        case .none:
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
        case .focus:
            layer.borderWidth = 3.scale
            layer.borderColor = Appearance.mainColor.cgColor
        }
    }
}

// MARK: Make constraints
private extension ReportMessageView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18.scale),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18.scale),
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReportMessageView {
    func makeTextView() -> UITextView {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(24.scale)
            .textColor(Appearance.blackColor)
        
        let view = UITextView()
        view.backgroundColor = UIColor.clear
        view.typingAttributes = attrs.dictionary
        view.showsVerticalScrollIndicator = false
        view.textContainerInset = UIEdgeInsets(top: 16.scale, left: 15.scale, bottom: 16.scale, right: 15.scale)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlaceholderLabel() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(24.scale)
            .textColor(Appearance.blackColor.withAlphaComponent(0.5))
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Report.Message.Placeholder".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
