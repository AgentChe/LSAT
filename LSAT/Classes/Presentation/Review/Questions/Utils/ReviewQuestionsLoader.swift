//
//  ReviewQuestionsLoader.swift
//  Nursing
//
//  Created by Андрей Чернышев on 19.06.2022.
//

import RxSwift
import RxCocoa

final class ReviewQuestionsLoader {
    private var loader: PaginatedDataLoader<Review>!

    private let nextPage: Observable<Void>

    init(nextPage: Observable<Void>) {
        self.nextPage = nextPage
    }

    func load(factory: @escaping (Int) -> Observable<Page<Review>>) -> Driver<[Review]> {
        let firstTrigger = Observable<Void>
            .deferred {
                .just(Void())
            }

        let nextTrigger = nextPage
            .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.asyncInstance)

        loader = PaginatedDataLoader(firstTrigger: firstTrigger,
                                     nextTrigger: nextTrigger,
                                     observableFactory: factory)

        return loader.elements
    }
}
