//
//  StatsTableView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 27.01.2021.
//

import UIKit

final class StatsTableView: UITableView {
    private lazy var elements = [StatsCellType]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension StatsTableView {
    func setup(elements: [StatsCellType]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension StatsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .passRate(value):
            let cell = dequeueReusableCell(withIdentifier: String(describing: PassRateCell.self), for: indexPath) as! PassRateCell
            cell.setup(percent: value)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case let .main(value):
            let cell = dequeueReusableCell(withIdentifier: String(describing: MainRateCell.self), for: indexPath) as! MainRateCell
            cell.setup(model: value)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        case let .course(value):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CourseProgressCell.self), for: indexPath) as! CourseProgressCell
            cell.setup(model: value)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: Private
private extension StatsTableView {
    func initialize() {
        register(PassRateCell.self, forCellReuseIdentifier: String(describing: PassRateCell.self))
        register(MainRateCell.self, forCellReuseIdentifier: String(describing: MainRateCell.self))
        register(CourseProgressCell.self, forCellReuseIdentifier: String(describing: CourseProgressCell.self))
        separatorStyle = .none
        
        dataSource = self
    }
}
