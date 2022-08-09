//
//  ReviewQuestionsTableView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 19.06.2022.
//

import UIKit

protocol ReviewQuestionsTableViewDelegate: AnyObject {
    func reviewQuestionsTableDidReachedBottom()
    func reviewQuestionsTableDidTapped(element: Review)
}

final class ReviewQuestionsTableView: UITableView {
    weak var mainDelegate: ReviewQuestionsTableViewDelegate?
    
    private(set) lazy var elements = [ReviewQuestionsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ReviewQuestionsTableView {
    func setup(elements: [ReviewQuestionsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ReviewQuestionsTableView: UITableViewDataSource {
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
        case .review(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ReviewQuestionsTableCell.self)) as! ReviewQuestionsTableCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ReviewQuestionsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .review:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (elements.count - 1) == indexPath.row {
            mainDelegate?.reviewQuestionsTableDidReachedBottom()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .review(element) = elements[indexPath.row] else {
            return
        }
        
        mainDelegate?.reviewQuestionsTableDidTapped(element: element)
    }
}

// MARK: Private
private extension ReviewQuestionsTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(ReviewQuestionsTableCell.self, forCellReuseIdentifier: String(describing: ReviewQuestionsTableCell.self))
        
        dataSource = self
        delegate = self
    }
}
