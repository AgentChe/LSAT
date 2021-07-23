//
//  QuestionsCollectionView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 05.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class QuestionsCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        register(QuestionViewCell.self, forCellWithReuseIdentifier: String(describing: QuestionViewCell.self))
        dataSource = self
        delegate = self
    }
    
    func setup(elements: [QuestionElement]) {
        self.elements = elements
        reloadData()
    }
    
    let selectedAnswersRelay = PublishRelay<AnswerElement>()
    
    private lazy var elements: [QuestionElement] = []
    private var currentIndex: IndexPath? = nil
}

extension QuestionsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: QuestionViewCell.self), for: indexPath) as! QuestionViewCell
        
        cell.configure(question: element) { [selectedAnswersRelay] elements in
            let element = AnswerElement(questionId: element.id, answerIds: elements, isMultiple: element.isMultiple)
            selectedAnswersRelay.accept(element)
        }
        
        return cell
    }
}

extension QuestionsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return frame.size
    }
}

extension QuestionsCollectionView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let cell = visibleCells.last {
            currentIndex = indexPath(for: cell)
        }
    }
}
