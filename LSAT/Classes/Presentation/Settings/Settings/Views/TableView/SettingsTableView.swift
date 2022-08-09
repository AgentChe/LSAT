//
//  SettingsTableView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit

protocol SettingsTableDelegate: AnyObject {
    func settingsTableDidTappedUnlockPremium()
    func settingsTableDidTappedCourse()
    func settingsTableDidTappedExamDate()
    func settingsTableDidTappedResetProgress()
    func settingsTableDidTappedTestMode()
    func settingsTableDidChanged(vibration: Bool)
    func settingsTableDidTappedTextSize()
    func settingsTableDidTappedRateUs()
    func settingsTableDidTappedJoinTheCommunity(url: String)
    func settingsTableDidTappedShareWithFriend()
    func settingsTableDidTappedContactUs()
    func settingsTableDidTappedTermsOfUse()
    func settingsTableDidTappedPrivacyPolicy()
}

final class SettingsTableView: UITableView {
    weak var mainDelegate: SettingsTableDelegate?
    
    lazy var elements = [SettingsTableElement]()
    
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
    func setup(elements: [SettingsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension SettingsTableView: UITableViewDataSource {
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
        case .unlockPremium:
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsUnlockPremiumCell.self)) as! SettingsUnlockPremiumCell
            cell.tableDelegate = mainDelegate
            return cell
        case .premium(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsPremiumCell.self)) as! SettingsPremiumCell
            cell.setup(element: element)
            return cell
        case .exam(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsExamCell.self)) as! SettingsExamCell
            cell.tableDelegate = mainDelegate
            cell.setup(element: element)
            return cell
        case .study(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsStudyCell.self)) as! SettingsStudyCell
            cell.tableDelegate = mainDelegate
            cell.setup(element: element)
            return cell
        case .community(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsCommunityCell.self)) as! SettingsCommunityCell
            cell.tableDelegate = mainDelegate
            cell.setup(element: element)
            return cell
        case .support:
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsSupportCell.self)) as! SettingsSupportCell
            cell.tableDelegate = mainDelegate
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .unlockPremium:
            return 93.scale
        case .exam, .study, .support:
            return 185.scale
        case .premium, .community:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension SettingsTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(SettingsUnlockPremiumCell.self, forCellReuseIdentifier: String(describing: SettingsUnlockPremiumCell.self))
        register(SettingsPremiumCell.self, forCellReuseIdentifier: String(describing: SettingsPremiumCell.self))
        register(SettingsExamCell.self, forCellReuseIdentifier: String(describing: SettingsExamCell.self))
        register(SettingsStudyCell.self, forCellReuseIdentifier: String(describing: SettingsStudyCell.self))
        register(SettingsCommunityCell.self, forCellReuseIdentifier: String(describing: SettingsCommunityCell.self))
        register(SettingsSupportCell.self, forCellReuseIdentifier: String(describing: SettingsSupportCell.self))
        
        dataSource = self
        delegate = self
    }
}
