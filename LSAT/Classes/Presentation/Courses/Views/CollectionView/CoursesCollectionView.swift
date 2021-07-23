//
//  CoursesCollectionView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit
import RxCocoa

final class CoursesCollectionView: UICollectionView {
    lazy var selected = PublishRelay<CoursesCollectionElement>()
    
    private lazy var elements = [CoursesCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension CoursesCollectionView {
    func setup(elements: [CoursesCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension CoursesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CourseCollectionCell.self), for: indexPath) as! CourseCollectionCell
        cell.setup(element: element)
        return cell
    }
}

// MARK: UICollectionViewDataSource
extension CoursesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let course = elements[indexPath.row].course
        
        return CGSize(width: course.isMain ? 343.scale : 164.scale,
                      height: course.isMain ? 164.scale : 171.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        
        selected.accept(element)
    }
}

// MARK: Private
private extension CoursesCollectionView {
    func initialize() {
        register(CourseCollectionCell.self, forCellWithReuseIdentifier: String(describing: CourseCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
