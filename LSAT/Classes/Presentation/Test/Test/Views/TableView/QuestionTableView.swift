//
//  QuestionTableView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class QuestionTableView: UITableView {
    let selectedAnswersRelay = PublishRelay<AnswerElement>()
    let expandContent = PublishRelay<QuestionContentType>()
    
    private lazy var elements = [TestingCellType]()
    
    private var selectedIds: (([Int]) -> Void)?
    private var isMultiple = false
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension QuestionTableView {
    func setup(question: QuestionElement) {
        selectedIds = { [weak self] elements in
            let element = AnswerElement(questionId: question.id, answerIds: elements, isMultiple: question.isMultiple)
            self?.selectedAnswersRelay.accept(element)
        }
        elements = question.elements
        isMultiple = question.isMultiple
        
        reloadData()
        
        let isBottomScroll = question.elements.contains(where: {
            guard case .result = $0 else { return false }
            return true
        })
        
        let indexPath = IndexPath(row: isBottomScroll ? question.elements.count - 1 : 0, section: 0)
        scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

// MARK: UITableViewDataSource
extension QuestionTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .content(content):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionContentCell.self), for: indexPath) as! QuestionContentCell
            cell.configure(content: content) { [weak self] in
                self?.expandContent.accept($0)
            }
            return cell
        case let .question(question, html, textSize):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionCell.self), for: indexPath) as! QuestionCell
            cell.configure(question: question, questionHtml: html, textSize: textSize)
            return cell
        case let .answers(answers, textSize):
            let cell = dequeueReusableCell(withIdentifier: String(describing: AnswersCell.self), for: indexPath) as! AnswersCell
            cell.configure(answers: answers, textSize: textSize, isMultiple: isMultiple, didTap: selectedIds)
            return cell
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
        case let .result(elements, textSize):
            let cell = dequeueReusableCell(withIdentifier: String(describing: AnswersCell.self), for: indexPath) as! AnswersCell
            cell.configure(result: elements, textSize: textSize)
            return cell
        case let .reference(reference):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionReferenceCell.self), for: indexPath) as! QuestionReferenceCell
            cell.confugure(reference: reference)
            return cell
        }
    }
}

extension QuestionTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .explanationImage(url) = elements[indexPath.row] else {
            return
        }
        
        expandContent.accept(.image(url))
    }
}

// MARK: Private
private extension QuestionTableView {
    func initialize() {
        register(QuestionContentCell.self, forCellReuseIdentifier: String(describing: QuestionContentCell.self))
        register(AnswersCell.self, forCellReuseIdentifier: String(describing: AnswersCell.self))
        register(QuestionCell.self, forCellReuseIdentifier: String(describing: QuestionCell.self))
        register(ExplanationImageCell.self, forCellReuseIdentifier: String(describing: ExplanationImageCell.self))
        register(ExplanationTextCell.self, forCellReuseIdentifier: String(describing: ExplanationTextCell.self))
        register(ExplanationTitleCell.self, forCellReuseIdentifier: String(describing: ExplanationTitleCell.self))
        register(QuestionReferenceCell.self, forCellReuseIdentifier: String(describing: QuestionReferenceCell.self))
        
        dataSource = self
        delegate = self
    }
}
