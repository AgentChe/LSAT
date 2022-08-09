//
//  QuestionViewerTableView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 20.06.2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol QuestionViewerTableDelegate: AnyObject {
    func questionViewerTableDidExpand(contentType: QuestionContentType)
}

final class QuestionViewerTableView: UITableView {
    weak var mainDelegate: QuestionViewerTableDelegate?
    
    private lazy var elements = [TestingCellType]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension QuestionViewerTableView {
    func setup(elements: [TestingCellType]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension QuestionViewerTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .content(content):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionContentCell.self), for: indexPath) as! QuestionContentCell
            cell.configure(content: content) { [weak self] in
                self?.mainDelegate?.questionViewerTableDidExpand(contentType: $0)
            }
            return cell
        case let .question(question, html, textSize):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionCell.self), for: indexPath) as! QuestionCell
            cell.configure(question: question, questionHtml: html, textSize: textSize)
            return cell
        case .answers:
            return UITableViewCell()
        case .explanationTitle:
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExplanationTitleCell.self), for: indexPath) as! ExplanationTitleCell
            return cell
        case let .explanationImage(url):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExplanationImageCell.self), for: indexPath) as! ExplanationImageCell
            cell.confugure(image: url)
            return cell
        case let .explanationText(explanation, html):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExplanationTextCell.self), for: indexPath) as! ExplanationTextCell
            cell.confugure(explanation: explanation, html: html)
            return cell
        case let .result(element, textSize):
            let cell = dequeueReusableCell(withIdentifier: String(describing: AnswersCell.self), for: indexPath) as! AnswersCell
            cell.configure(result: element, textSize: textSize)
            return cell
        case let .reference(reference):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionReferenceCell.self), for: indexPath) as! QuestionReferenceCell
            cell.confugure(reference: reference)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension QuestionViewerTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .explanationImage(url) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.questionViewerTableDidExpand(contentType: .image(url))
    }
}

// MARK: Private
private extension QuestionViewerTableView {
    func initialize() {
        register(QuestionContentCell.self, forCellReuseIdentifier: String(describing: QuestionContentCell.self))
        register(QuestionCell.self, forCellReuseIdentifier: String(describing: QuestionCell.self))
        register(AnswersCell.self, forCellReuseIdentifier: String(describing: AnswersCell.self))
        register(ExplanationImageCell.self, forCellReuseIdentifier: String(describing: ExplanationImageCell.self))
        register(ExplanationTextCell.self, forCellReuseIdentifier: String(describing: ExplanationTextCell.self))
        register(ExplanationTitleCell.self, forCellReuseIdentifier: String(describing: ExplanationTitleCell.self))
        register(QuestionReferenceCell.self, forCellReuseIdentifier: String(describing: QuestionReferenceCell.self))
        
        dataSource = self
        delegate = self
    }
}
