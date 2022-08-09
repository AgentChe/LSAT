//
//  StudyCollectionView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 30.01.2021.
//

import UIKit
import RxCocoa

final class StudyCollectionView: UICollectionView {
    lazy var selected = PublishRelay<StudyCollectionElement>()
    
    lazy var sections = [StudyCollectionSection]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension StudyCollectionView {
    func setup(sections: [StudyCollectionSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension StudyCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .brief(let brief):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCBriefCell.self), for: indexPath) as! SCBriefCell
            cell.setup(element: brief)
            return cell
        case .takeTest(let activeSubscription):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCTakeTestCell.self), for: indexPath) as! SCTakeTestCell
            cell.setup(activeSubscription: activeSubscription)
            return cell
        case .unlockAllQuestions:
            return dequeueReusableCell(withReuseIdentifier: String(describing: SCUnlockQuestionsCell.self), for: indexPath) as! SCUnlockQuestionsCell
        case .title(let title):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCTitleCell.self), for: indexPath) as! SCTitleCell
            cell.setup(title: title)
            return cell
        case .mode(let mode):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SCModeCell.self), for: indexPath) as! SCModeCell
            cell.setup(mode: mode)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegate
extension StudyCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected.accept(sections[indexPath.section].elements[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 375.scale - contentInset.left - contentInset.right
        
        switch sections[indexPath.section].elements[indexPath.row] {
        case .brief:
            return CGSize(width: width, height: 99.scale)
        case .takeTest:
            return CGSize(width: width, height: 75.scale)
        case .unlockAllQuestions:
            return CGSize(width: width, height: 75.scale)
        case .title:
            return CGSize(width: width, height: 56.scale)
        case .mode:
            return CGSize(width: 164, height: 120.scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        15.scale
    }
}

// MARK: Private
private extension StudyCollectionView {
    func initialize() {
        register(SCBriefCell.self, forCellWithReuseIdentifier: String(describing: SCBriefCell.self))
        register(SCTakeTestCell.self, forCellWithReuseIdentifier: String(describing: SCTakeTestCell.self))
        register(SCUnlockQuestionsCell.self, forCellWithReuseIdentifier: String(describing: SCUnlockQuestionsCell.self))
        register(SCTitleCell.self, forCellWithReuseIdentifier: String(describing: SCTitleCell.self))
        register(SCModeCell.self, forCellWithReuseIdentifier: String(describing: SCModeCell.self))
        
        dataSource = self
        delegate = self
    }
}
