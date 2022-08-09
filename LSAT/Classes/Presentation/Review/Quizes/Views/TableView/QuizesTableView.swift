//
//  QuizesTableView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 18.06.2022.
//

import UIKit

protocol QuizesTableViewDelegate: AnyObject {
    func quizesTableDidTapped(quiz: QuizesTableQuiz)
}

final class QuizesTableView: UITableView {
    weak var mainDelegate: QuizesTableViewDelegate?
    
    private(set) lazy var elements = [QuizesTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension QuizesTableView {
    func setup(elements: [QuizesTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension QuizesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .offset:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        case .day(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuizesTableDayCell.self)) as! QuizesTableDayCell
            cell.setup(element: element)
            return cell
        case .quiz(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: QuizesTableQuizCell.self)) as! QuizesTableQuizCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension QuizesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .day:
            return UITableView.automaticDimension
        case .quiz:
            return 141.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .quiz(quiz) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.quizesTableDidTapped(quiz: quiz)
    }
}

// MARK: Private
private extension QuizesTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(QuizesTableDayCell.self, forCellReuseIdentifier: String(describing: QuizesTableDayCell.self))
        register(QuizesTableQuizCell.self, forCellReuseIdentifier: String(describing: QuizesTableQuizCell.self))
        
        dataSource = self
        delegate = self
    }
}
