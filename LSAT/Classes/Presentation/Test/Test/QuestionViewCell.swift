//
//  QuestionViewCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 05.02.2021.
//

import UIKit

class QuestionViewCell: UICollectionViewCell {
    private lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tableView.scrollToRow(at: .init(row: 0, section: 0), at: .top, animated: false)
    }
    
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func makeTableView() -> QuestionTableView {
        let view = QuestionTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        contentView.addSubview(view)
        return view
    }
    
    func configure(question: QuestionElement, didTap: @escaping ([Int]) -> Void) {
        tableView.setup(question: question)
    }
}
