//
//  SettingsTableView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit
import RxCocoa

final class SettingsTableView: UITableView {
    enum Tapped {
        case unlock, course, rateUs, contactUs, termsOfUse, privacyPoliicy, mode(TestMode), references
    }
    
    lazy var tapped = PublishRelay<Tapped>()
    
    private lazy var sections = [SettingsTableSection]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension SettingsTableView {
    func setup(sections: [SettingsTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension SettingsTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .unlockPremium:
            let cell = dequeueReusableCell(withIdentifier: String(describing: STUnlockCell.self), for: indexPath) as! STUnlockCell
            cell.tapped = { [weak self] in
                self?.tapped.accept(.unlock)
            }
            return cell
        case .selectedCourse(let course):
            let cell = dequeueReusableCell(withIdentifier: String(describing: STCourseCell.self), for: indexPath) as! STCourseCell
            cell.setup(course: course)
            cell.tapped = { [weak self] in
                self?.tapped.accept(.course)
            }
            return cell
        case .links:
            let cell = dequeueReusableCell(withIdentifier: String(describing: STLinksCell.self), for: indexPath) as! STLinksCell
            cell.tapped = { [weak self] value in
                self?.tapped.accept(value)
            }
            return cell
        case .mode(let mode):
            let cell = dequeueReusableCell(withIdentifier: String(describing: STModeCell.self), for: indexPath) as! STModeCell
            cell.setup(mode: mode)
            cell.tapped = { [weak self] mode in
                self?.tapped.accept(.mode(mode))
            }
            return cell
        case .references:
            let cell = dequeueReusableCell(withIdentifier: String(describing: STReferencesCell.self), for: indexPath) as! STReferencesCell
            cell.tapped = { [weak self] in
                self?.tapped.accept(.references)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20.scale
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case .unlockPremium:
            return 93.scale
        case .selectedCourse:
            return 75.scale
        case .links:
            return 200.scale
        case .mode:
            return 51.scale
        case .references:
            return 51.scale
        }
    }
}

// MARK: Private
private extension SettingsTableView {
    func initialize() {
        register(STUnlockCell.self, forCellReuseIdentifier: String(describing: STUnlockCell.self))
        register(STCourseCell.self, forCellReuseIdentifier: String(describing: STCourseCell.self))
        register(STLinksCell.self, forCellReuseIdentifier: String(describing: STLinksCell.self))
        register(STModeCell.self, forCellReuseIdentifier: String(describing: STModeCell.self))
        register(STReferencesCell.self, forCellReuseIdentifier: String(describing: STReferencesCell.self))
        
        dataSource = self
        delegate = self
    }
}
