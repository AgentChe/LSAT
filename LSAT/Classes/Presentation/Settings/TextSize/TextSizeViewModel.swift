//
//  TextSizeViewModel.swift
//  Nursing
//
//  Created by Андрей Чернышев on 25.05.2022.
//

import RxSwift
import RxCocoa

final class TextSizeViewModel {
    lazy var minus = PublishRelay<Void>()
    lazy var plus = PublishRelay<Void>()
    
    lazy var currentTextSize = makeCurrentTextSize()
    
    private lazy var textSizes = makeTextSizes()
    
    private lazy var profileManager = ProfileManager()
}

// MARK: Private
private extension TextSizeViewModel {
    func makeCurrentTextSize() -> Driver<TextSize> {
        let initial = profileManager
            .obtainStudySettings()
            .map { $0.textSize }
            .asDriver(onErrorDriveWith: .never())

        let updated = initial.flatMapLatest { _ in
            self.makeActions()
        }
        
        return Driver.merge(initial, updated)
    }
    
    func makeActions() -> Driver<TextSize> {
        Observable
            .merge(
                minus.map { -1 },
                plus.map { 1 }
            )
            .withLatestFrom(currentTextSize) { ($0, $1) }
            .withLatestFrom(textSizes) { ($0.0, $0.1, $1) }
            .compactMap { coef, currentTextSize, textSizes -> TextSize? in
                guard let currentIndex = textSizes.firstIndex(of: currentTextSize) else {
                    return nil
                }
                
                let index = currentIndex + coef
                
                guard textSizes.indices.contains(index) else {
                    return nil
                }
                
                return textSizes[index]
            }
            .flatMapLatest { [weak self] textSize -> Single<TextSize> in
                guard let self = self else {
                    return .never()
                }
                
                return self.profileManager
                    .set(selectedTextSize: textSize)
                    .map { textSize }
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeTextSizes() -> Driver<[TextSize]> {
        .deferred {
            .just([
                TextSize(percent: 80),
                TextSize(percent: 90),
                TextSize(percent: 100),
                TextSize(percent: 110),
                TextSize(percent: 120)
            ])
        }
    }
}
