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
    private lazy var elements = [TestingCellType]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var selectedIds: (([Int]) -> Void)?
    private var isMultiple = false
    let selectedAnswersRelay = PublishRelay<AnswerElement>()
    let expandContent = PublishRelay<QuestionContentType>()
}

// MARK: API
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
        case let .questionsProgress(progress):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionsProgressCell.self), for: indexPath) as! QuestionsProgressCell
            cell.configure(title: progress)
            return cell
        case let .content(content):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionContentCell.self), for: indexPath) as! QuestionContentCell
            cell.configure(content: content) { [weak self] in
                self?.expandContent.accept($0)
            }
             return cell
        case let .question(question, html):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionCell.self), for: indexPath) as! QuestionCell
            cell.configure(question: question, questionHtml: html)
            return cell
        case let .answers(answers):
            let cell = dequeueReusableCell(withIdentifier: String(describing: AnswersCell.self), for: indexPath) as! AnswersCell
            cell.configure(answers: answers, isMultiple: isMultiple, didTap: selectedIds)
            return cell
        case let .explanation(explanation, html):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExplanationCell.self), for: indexPath) as! ExplanationCell
            cell.confugure(explanation: explanation, html: html)
            return cell
        case let .result(elements):
            let cell = dequeueReusableCell(withIdentifier: String(describing: AnswersCell.self), for: indexPath) as! AnswersCell
            cell.configure(result: elements)
            return cell
        case let .reference(reference):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuestionReferenceCell.self), for: indexPath) as! QuestionReferenceCell
            cell.confugure(reference: reference)
            return cell
        }
    }
}

// MARK: Private
private extension QuestionTableView {
    func initialize() {
        register(QuestionsProgressCell.self, forCellReuseIdentifier: String(describing: QuestionsProgressCell.self))
        register(QuestionContentCell.self, forCellReuseIdentifier: String(describing: QuestionContentCell.self))
        register(AnswersCell.self, forCellReuseIdentifier: String(describing: AnswersCell.self))
        register(QuestionCell.self, forCellReuseIdentifier: String(describing: QuestionCell.self))
        register(ExplanationCell.self, forCellReuseIdentifier: String(describing: ExplanationCell.self))
        register(QuestionReferenceCell.self, forCellReuseIdentifier: String(describing: QuestionReferenceCell.self))
        
        separatorStyle = .none
        
        dataSource = self
    }
}
