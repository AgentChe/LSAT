//
//  ReferencesTableView.swift
//  FNP
//
//  Created by Andrey Chernyshev on 10.07.2021.
//

import UIKit

final class ReferencesTableView: UITableView {
    lazy var references = [Reference]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ReferencesTableView {
    func setup(references: [Reference]) {
        self.references = references
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ReferencesTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        references.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: ReferencesTableCell.self)) as! ReferencesTableCell
        cell.setup(reference: references[indexPath.section])
        return cell
    }
}

// MARK: UITableViewDelegate
extension ReferencesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        16.scale
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let url = URL(string: references[indexPath.section].link ?? ""),
            UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
}

// MARK: Private
private extension ReferencesTableView {
    func initialize() {
        dataSource = self
        delegate = self
        
        register(ReferencesTableCell.self, forCellReuseIdentifier: String(describing: ReferencesTableCell.self))
    }
}
